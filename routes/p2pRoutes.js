import { prismaClient } from "../utils/prisma.js";
import { validateAvailableChainId, validateRequiredFields } from "../utils/validator.js";

export const p2pRoutes = async (server) => {
  // Fetch all active listings
  // TODO: Implement listing retrieval from the database
  server.get('/listings', async (request, reply) => {
    try {
      let { isActive, userId } = request.query;
      isActive = isActive === undefined ? undefined : isActive === 'true' ? true : false;

      const listings = await prismaClient.p2PListing.findMany({
        where: {
          isActive: isActive,
          userId: userId
        },
        orderBy: {
          createdAt: 'asc'
        }
      })

      return reply.send(listings);
    } catch (error) {
      return reply.code(500).send({ message: error });
    }
  });

  // Create a new listing
  // TODO: Implement new listing creation and depositing funds to CengliP2PReserve contract
  server.post('/listings', async (request, reply) => {
    try {
      const {
        userId, userAddress,
        tokenAddress, tokenChainId, amount
      } = request.body;

      // validate required body parameters, similar to transferRoutes.js
      await validateRequiredFields(request.body, ['userId', 'userAddress', 'tokenAddress', 'tokenChainId', 'amount'], reply);
      await validateAvailableChainId([tokenChainId], reply);

      // validate it's the correct token
      const token = await prismaClient.token.findUniqueOrThrow({
        where: {
          address_chainId: {
            address: tokenAddress,
            chainId: tokenChainId
          }
        }
      }).catch(error => {
        return reply.code(400).send({ message: 'Invalid token' });
      })

      // create listing in database
      const listing = await prismaClient.p2PListing.create({
        data: {
          userId: userId,
          userAddress: userAddress,
          tokenAddress: tokenAddress,
          tokenChainId: tokenChainId,
          amount: amount,
          availableAmount: amount,
          // TODO: disable true isActive laater
          isActive: true
        }
      })


      // TODO: deposit funds to CengliP2PReserve contract

      // TODO: update listing availableAmount and depositTxHash

      // TODO: update listing isActive

      return reply.send(listing);
    } catch (error) {
      return reply.code(500).send({ message: error });
    }
  });

  // Fetch all orders (for admin)
  // TODO: Implement orders retrieval from the database
  server.get('/orders', async (request, reply) => {
    try {
      const { listingId, statuses, orderId } = request.query;

      await validateRequiredFields(request.query, ['listingId'], reply);

      const statusesArr = statuses ? statuses.split(',') : undefined;
      if (statusesArr && statusesArr.length > 0) {
        // check if all statuses are valid
        const availableStatuses = ['WFSAC', 'WFBP', 'WFSA', 'C', 'CB', 'CS'];
        const invalidStatuses = statusesArr.filter(status => !availableStatuses.includes(status));

        if (invalidStatuses.length > 0) {
          return reply.code(400).send({ message: `Invalid statuses: ${invalidStatuses.join(', ')}. The available statuses are: ${availableStatuses.join(', ')}` });
        }
      }

      const orders = await prismaClient.p2POrder.findMany({
        where: {
          listingId: listingId,
          status: statusesArr ? {
            in: statusesArr
          } : undefined,
          id: orderId
        },
        include: {
          chat: true
        },
        orderBy: {
          createdAt: 'asc'
        }
      })

      return reply.send(orders);
    } catch (error) {
      console.log('Error fetching orders: ', error);
      return reply.code(500).send({ message: error });
    }
  });

  server.get('/orders/:id', async (request, reply) => {
    try {
      const { id } = request.params;
      if (!id) {
        return reply.code(400).send({ message: 'Invalid order id' });
      }

      const order = await prismaClient.p2POrder.findUnique({
        where: {
          id: id
        },
        include: {
          chat: true,
          listing: true
        }
      })

      if (!order) {
        return reply.code(400).send({ message: 'Order not found' });
      }

      return reply.send(order);
    } catch (error) {
      return reply.code(500).send({ message: error });
    }
  });

  // Create a new order
  // TODO: Implement new order creation, change listing status to WFPA
  server.post('/orders', async (request, reply) => {
    try {
      const { listingId, buyerUserId, buyerAddress, amount, chatId, destinationChainId } = request.body;

      await validateRequiredFields(request.body, ['listingId', 'buyerUserId', 'buyerAddress', 'amount', 'chatId', 'destinationChainId'], reply);
      await validateAvailableChainId([parseInt(destinationChainId)], reply);

      // validate listing exists
      const listing = await prismaClient.p2PListing.findUniqueOrThrow({
        where: {
          id: listingId,
          isActive: true,

        }
      }).catch(error => {
        return reply.code(400).send({ message: 'Invalid listing, make sure the listing is active or exists' });
      })

      // TODO: validate buyer has enough balance

      // TODO: validate buyer has enough allowance

      // TODO: validate buyer has enough balance in CengliP2PReserve contract

      const order = await prismaClient.p2POrder.create({
        data: {
          listingId: listingId,
          buyerUserId: buyerUserId,
          buyerAddress: buyerAddress,
          destinationChainId: parseInt(destinationChainId),
          amount: amount,
          status: 'WFSAC',
          chat: {
            create: {
              chatId: chatId
            }
          }
        },
        include: {
          chat: true
        }
      })

      return reply.send(order);
    } catch (error) {
      return reply.code(500).send({ message: error });
    }
  });

  // Accept an order by partner
  // TODO: Change order status to WFBP, initiate chat
  server.put('/orders/:id/accept', async (request, reply) => {
    const { id } = request.params;
    const { callerUserId } = request.query

    await validateRequiredFields(request.params, ['id'], reply);

    // TODO: Make the listing creator the only one who can accept the order

    // check if order exists
    const order = await prismaClient.p2POrder.findFirst({
      where: {
        id: id,
        status: 'WFSAC',
        isActive: true
      },
      include: {
        listing: true
      }
    })
    if (!order) {
      return reply.code(400).send({ message: 'Invalid order, make sure the order exists and is in WFSAC status' });
    }

    // TODO: validate partner has enough availableAmount deposited in CengliP2PReserve contract

    // Make the partner the only one who can accept the order
    if (callerUserId !== order.listing.userId) {
      return reply.code(400).send({ message: 'Invalid caller, make sure the caller is the partner' });
    }

    // update order status
    const updatedOrder = await prismaClient.p2POrder.update({
      where: {
        id: id
      },
      data: {
        status: 'WFBP'
      }
    })

    return reply.send(updatedOrder);
  });

  // Cancel an order by partner or buyer
  // TODO: Change order status to CNCL
  server.put('/orders/:id/cancel', async (request, reply) => {
    const { id } = request.params;
    const { callerUserId } = request.query

    // TODO: Make the listing participant the only one who can cancel the order

    await validateRequiredFields(request.params, ['id'], reply);

    const order = await prismaClient.p2POrder.findFirst({
      where: {
        id: id,
        status: {
          in: ['WFSAC', 'WFBP']
        },
        isActive: true
      },
      include: {
        listing: true
      }
    })
    if (!order) {
      return reply.code(400).send({ message: 'Invalid order, make sure the order exists and is active and in WFSAC or WFBP status' });
    }

    // If cancelled when in WFSAC status
    if (order.status === 'WFSAC') {
      // validate it's from the buyer or partner
      if (callerUserId !== order.buyerUserId && callerUserId !== order.listing.userId) {
        return reply.code(400).send({ message: 'Invalid caller, make sure the caller is the buyer or partner' });
      }
    }

    // If cancelled when in WFBP status
    if (order.status === 'WFBP') {
      // validate it's from the partner
      if (callerUserId !== order.buyerUserId) {
        return reply.code(400).send({ message: 'Invalid caller, make sure the caller is the partner' });
      }
    }

    let status = ''
    if (callerUserId === order.buyerUserId) {
      status = 'CB'
    } else if (callerUserId === order.listing.userId) {
      status = 'CS'
    }

    const updatedOrder = await prismaClient.p2POrder.update({
      where: {
        id: id
      },
      data: {
        status: status,
        isActive: false,
        chat: {
          update: {
            isActive: false
          }
        }
      }
    })

    return reply.send(updatedOrder);
  });

  // Mark payment as done by the buyer
  // TODO: Change order status, notify partner
  server.put('/orders/:id/done-payment', async (request, reply) => {
    const { id } = request.params;
    const { callerUserId } = request.query

    await validateRequiredFields(request.params, ['id'], reply);

    const order = await prismaClient.p2POrder.findFirst({
      where: {
        id: id,
        status: 'WFBP',
        isActive: true
      }
    })

    if (!order) {
      return reply.code(400).send({ message: 'Invalid order, make sure the order exists and is in WFBP status' });
    }

    // make the buyer the only one who can mark payment as done
    if (callerUserId !== order.buyerUserId) {
      return reply.code(400).send({ message: 'Invalid caller, make sure the caller is the buyer' });
    }

    // update order status
    const updatedOrder = await prismaClient.p2POrder.update({
      where: {
        id: id
      },
      data: {
        status: 'WFSA'
      }
    })

    return reply.send(updatedOrder);
  });

  // Release funds to buyer
  // TODO: Trigger smart contract to transfer USDC from CengliP2PReserve to buyer
  server.put('/orders/:id/release-fund', async (request, reply) => {
    const { id } = request.params;
    const { callerUserId } = request.query

    await validateRequiredFields(request.params, ['id'], reply);

    const order = await prismaClient.p2POrder.findFirst({
      where: {
        id: id,
        status: 'WFSA',
        isActive: true
      },
      include: {
        listing: true
      }
    })

    if (!order) {
      return reply.code(400).send({ message: 'Invalid order, make sure the order exists and is in WFSA status' });
    }

    // make the partner the only one who can release funds
    if (callerUserId !== order.listing.userId) {
      return reply.code(400).send({ message: 'Invalid caller, make sure the caller is the partner' });
    }

    // TODO: transfer USDC from CengliP2PReserve to buyer

    // update order status
    const updatedOrder = await prismaClient.p2POrder.update({
      where: {
        id: id
      },
      data: {
        status: 'C',
        isActive: false,
        chat: {
          update: {
            isActive: false
          }
        },
      }
    })

    return reply.send(updatedOrder);
  });
};
