import { prismaClient } from "../utils/prisma.js";
import { validateAvailableChainId, validateRequiredFields } from "../utils/validator.js";
import { EscrowContractAddress, cancelOrder, checkAllowance, checkBalance, depositToEscrow, releaseFunds } from "../utils/web3/p2pController.js";

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
      const { userId, userAddress, name } = request.body;
      await validateRequiredFields(request.body, ['userId', 'userAddress', 'name'], reply);

      const partner = await prismaClient.p2PPartner.upsert({
        where: {
          userId: userId,
          address: userAddress
        },
        create: {
          userId: userId,
          address: userAddress,
          name: name ? name : 'Name not set'
        },
        update: {
          name: name ? name : 'Name not set'
        }
      })
      
      return reply.send(partner);
    } catch (error) {
      console.log('Error adding partner: ', error);
      return reply.code(500).send({ message: error });
    }
  })

  // Fetch all orders (for admin)
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
          chat: true,
          token: true
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

  // checkAllowance('0xEd5f3482A1500321c90521604922E9822211C542', '0x2e6a3E97f7FeB5564eE0C11e56FE9970945384e5', '0x3999032F30A9be2Fd2732B4cFe3e61ADe9531509')
  // checkBalance('0xEd5f3482A1500321c90521604922E9822211C542', '0x2e6a3E97f7FeB5564eE0C11e56FE9970945384e5')

  // Create a new order
  server.post('/orders', async (request, reply) => {
    try {
      const { partnerId, buyerUserId, buyerAddress, amount, chatId, destinationChainId, tokenAddress, orderId } = request.body;

      await validateRequiredFields(request.body, ['partnerId', 'buyerUserId', 'buyerAddress', 'amount', 'chatId', 'destinationChainId', 'tokenAddress'], reply);
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

      // get avax token
      const token = await prismaClient.token.findFirst({
        where: {
          chainId: destinationChainId,
          address: tokenAddress.toLowerCase()
        }
      })

      if (!token) {
        return reply.code(400).send({ message: 'Invalid token, make sure it is the correct address and chain id' });
      }

      // validate partner has enough balance
      const sellerBalance = await checkBalance(token.address, partner.address)
      if (sellerBalance < amount) {
        return reply.code(400).send({ message: 'Invalid amount, make sure the partner has enough balance' });
      }

      const order = await prismaClient.p2POrder.create({
        data: {
          id: orderId ? orderId : undefined,
          partnerId: partnerId,
          buyerUserId: buyerUserId,
          buyerAddress: buyerAddress,
          destinationChainId: parseInt(destinationChainId),
          tokenAddress: token.address,
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
          token: true,
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
  server.put('/orders/:id/accept', async (request, reply) => {
    try {
      const { id } = request.params;
      const { callerUserId } = request.query

      await validateRequiredFields(request.params, ['id'], reply);

      // check if order exists
      const order = await prismaClient.p2POrder.findFirst({
        where: {
          id: id,
          status: 'WFSAC',
          isActive: true
        },
        include: {
          partner: true,
          token: true
        }
      })
      if (!order) {
        return reply.code(400).send({ message: 'Invalid order, make sure the order exists and is in WFSAC status' });
      }

      // Make the partner the only one who can accept the order
      if (callerUserId !== order.partner.userId) {
        return reply.code(400).send({ message: 'Invalid caller, make sure the caller is the partner' });
      }

      // validate partner has enough allowance to CengliP2PReserve contract
      const partnerAllowance = await checkAllowance(order.token.address, order.partner.address, EscrowContractAddress)
      if (partnerAllowance < order.amount) {
        return reply.code(400).send({ message: 'The partner does not have enough allowance to CengliP2PReserve contract' });
      }

      // transfer tokens from partner to CengliP2PReserve contract
      await depositToEscrow(order.buyerAddress, order.partner.address, order.token.address, order.amount * Math.pow(10, order.token.decimals), order.id)

      // update order status
      const updatedOrder = await prismaClient.p2POrder.update({
        where: {
          id: id
        },
        data: {
          status: 'WFBP'
        },
        include: {
          deposit: true
        }
      })

      return reply.send(updatedOrder);
    } catch (error) {
      console.log('Error accepting order: ', error);
      return reply.code(500).send({ message: error });
    }
  });

  // Cancel an order by partner or buyer
  server.put('/orders/:id/cancel', async (request, reply) => {
    try {
      const { id } = request.params;
      const { callerUserId } = request.query

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
          deposit: true,
        }
      })
      if (!order) {
        return reply.code(400).send({ message: 'Invalid order, make sure the order exists and is active and in WFSAC or WFBP status' });
      }

      if (order.deposit?.contractOrderId === null || order.deposit?.contractOrderId === undefined) {
        // just update order status
        let status = ''
        if (callerUserId === order.buyerUserId) {
          status = 'CB'
        } else if (callerUserId === order.partner.userId) {
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

      // Refund the deposit to the partner
      await cancelOrder(parseInt(order.deposit.contractOrderId))

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
          partner: true,
          deposit: true,
        }
      })

      if (!order) {
        return reply.code(400).send({ message: 'Invalid order, make sure the order exists and is in WFSA status' });
      }

      // make the partner the only one who can release funds
      if (callerUserId !== order.partner.userId) {
        return reply.code(400).send({ message: 'Invalid caller, make sure the caller is the partner' });
      }

      // Transfer fund from Escrow contract to buyer
      await releaseFunds(parseInt(order.deposit?.contractOrderId))

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
      console.log('Error releasing funds: ', error);
      return reply.code(500).send({ message: error });
    }
  });
};
