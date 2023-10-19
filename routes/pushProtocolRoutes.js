import { prismaClient } from "../utils/prisma.js";
import { validateRequiredFields } from "../utils/validator.js";

export const pushProtocolRoutes = async (server) => {
  // Create & Update user's FCM token. params: walletAddress, fcmToken
  server.post('/user-fcm-token', async (request, reply) => {
    try {
      const { walletAddress, fcmToken } = request.body;

      await validateRequiredFields(request.body, ['walletAddress', 'fcmToken'], reply);

      const userNotification = await prismaClient.userNotification.upsert({
        where: {
          walletAddress: walletAddress,
        },
        update: {
          fcmToken: fcmToken,
        },
        create: {
          walletAddress: walletAddress,
          fcmToken: fcmToken,
        }
      })

      return reply.code(200).send(userNotification);
    } catch (error) {
      console.error('An error occurred:', error);
      return reply.code(500).send({ message: error });
    }
  })

  // TODO: Subscribe to Push Protocol channel, will be called after create wallet. params: walletAddress. 
  server.post('/subscribe-channel', async (request, reply) => {
    const { walletAddress } = request.body;

    await validateRequiredFields(request.body, ['walletAddress'], reply);

    return reply.code(200).send({ message: 'Not implemented yet' });
  })

  // TODO: Send notification to user with Push Protocol, params: walletAddress[] + notif payload (title, body, screen)
  server.post('/send-notification', async (request, reply) => {
    const { walletAddresses, notificationPayload } = request.body;

    await validateRequiredFields(request.body, ['walletAddresses', 'notificationPayload'], reply);

    return reply.code(200).send({ message: 'Not implemented yet' });
  })


  // TODO: Send notification to user with Firebase, using fcmToken
  const sendFirebaseNotification = async (fcmToken, notificationPayload) => {

  }

  
}