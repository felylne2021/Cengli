import { prismaClient } from "../utils/prisma.js";
import { validateAvailableChainId, validateRequiredFields } from "../utils/validator.js";

export const p2pRoutes = async (server) => {
  // Fetch all active partners
  server.get('/partners', async (request, reply) => {
    try {
      const partners = await prismaClient.p2PPartner.findMany({
        include: {
          balances: {
            where: {
              token: {
                symbol: 'USDC'
              }
            },
            include: {
              token: true
            }
          }
        },
        orderBy: {
          createdAt: 'asc'
        }
      })

      return reply.send(partners);
    } catch (error) {
      return reply.code(500).send({ message: error });
    }
  });

  // Add a new partner
  server.post('/partners', async (request, reply) => {
    try {
      const { userId, userAddress } = request.body;
      await validateRequiredFields(request.body, ['userId', 'userAddress'], reply);

      // check if partner already exists
      const partnerExists = await prismaClient.p2PPartner.findFirst({
        where: {
          userId: userId,
          address: userAddress
        },
        include: {
          balances: {
            where: {
              token: {
                symbol: 'USDC'
              }
            },
            include: {
              token: true
            }
          }
        }
      })

      if (partnerExists) {
        return reply.code(400).send(partnerExists);
      }

      const partner = await prismaClient.p2PPartner.create({
        data: {
          userId: userId,
          address: userAddress
        }
      })
      return reply.send(partner);
    } catch (error) {
      console.log('Error adding partner: ', error);
      return reply.code(500).send({ message: error });
    }
  })

  // Fetch all orders (for admin)
  // TODO: Implement orders retrieval from the database
  server.get('/orders', async (request, reply) => {
    try {
      const { partnerId, statuses } = request.query;

      await validateRequiredFields(request.query, ['partnerId'], reply);

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
          partnerId: partnerId,
          status: statusesArr ? {
            in: statusesArr
          } : undefined
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
          chat: true
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
      const { partnerId, buyerUserId, buyerAddress, amount, chatId, destinationChainId, orderId } = request.body;

      await validateRequiredFields(request.body, ['partnerId', 'buyerUserId', 'buyerAddress', 'amount', 'chatId', 'destinationChainId'], reply);
      await validateAvailableChainId([parseInt(destinationChainId)], reply);

      console.log('partnerId: ', partnerId);
      // validate if partner exists
      const partner = await prismaClient.p2PPartner.findUnique({
        where: {
          id: partnerId
        }
      })

      if (!partner) {
        return reply.code(400).send({ message: 'Invalid partner id' });
      }

      // if order id is provided, validate it's unique
      if (orderId) {
        const orderExists = await prismaClient.p2POrder.findFirst({
          where: {
            id: orderId
          }
        })

        if (orderExists) {
          return reply.code(400).send({ message: 'Invalid order id, make sure the order id is unique' });
        }
      }

      // TODO: validate buyer has enough balance

      // TODO: validate buyer has enough allowance

      // TODO: validate buyer has enough balance in CengliP2PReserve contract

      const order = await prismaClient.p2POrder.create({
        data: {
          id: orderId ? orderId : undefined,
          partnerId: partnerId,
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
          chat: true,
          partner: {
            include: {
              balances: {
                include: {
                  token: true
                }
              }
            }
          }
        }
      })

      return reply.send(order);
    } catch (error) {
      console.log('Error creating order: ', error);
      return reply.code(500).send({ message: error });
    }
  });

  // Accept an order by partner
  // TODO: Change order status to WFBP, initiate chat
  server.put('/orders/:id/accept', async (request, reply) => {
    try {
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
          partner: true,
        }
      })
      if (!order) {
        return reply.code(400).send({ message: 'Invalid order, make sure the order exists and is in WFSAC status' });
      }

      // TODO: validate partner has enough allowance to CengliP2PReserve contract

      // Make the partner the only one who can accept the order
      if (callerUserId !== order.partner.userId) {
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
    } catch (error) {
      console.log('Error accepting order: ', error);
      return reply.code(500).send({ message: error });
    }
  });

  // Cancel an order by partner or buyer
  // TODO: Change order status to CNCL
  server.put('/orders/:id/cancel', async (request, reply) => {
    try {
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
          partner: true,
        }
      })
      if (!order) {
        return reply.code(400).send({ message: 'Invalid order, make sure the order exists and is active and in WFSAC or WFBP status' });
      }

      // If cancelled when in WFSAC status
      if (order.status === 'WFSAC') {
        // validate it's from the buyer or partner
        if (callerUserId !== order.buyerUserId && callerUserId !== order.partner.userId) {
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
    } catch (error) {
      return reply.code(500).send({ message: error });
    }
  });

  // Mark payment as done by the buyer
  // TODO: Change order status, notify partner
  server.put('/orders/:id/done-payment', async (request, reply) => {
    try {
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
    } catch (error) {
      return reply.code(500).send({ message: error });
    }
  });

  // Release funds to buyer
  // TODO: Trigger smart contract to transfer USDC from CengliP2PReserve to buyer
  server.put('/orders/:id/release-fund', async (request, reply) => {
    try {
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
          partner: true
        }
      })

      if (!order) {
        return reply.code(400).send({ message: 'Invalid order, make sure the order exists and is in WFSA status' });
      }

      // make the partner the only one who can release funds
      if (callerUserId !== order.partner.userId) {
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
    } catch (error) {
      return reply.code(500).send({ message: error });
    }
  });
};
