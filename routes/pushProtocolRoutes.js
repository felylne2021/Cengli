import { PushAPI } from "@pushprotocol/restapi";
import { ethers } from "ethers";
import axios from "axios";

import { prismaClient } from "../utils/prisma.js";
import { validateRequiredFields } from "../utils/validator.js";
import { PUSH_PROTOCOL_CHANNEL } from "../utils/constants.js";



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
    const { walletAddress, pgpk } = request.body;
    await validateRequiredFields(request.body, ['walletAddress', 'pgpk'], reply);

    const wallet = new ethers.Wallet(pgpk);
    const user = await PushAPI.initialize(wallet, {
      env: 'prod'
    });

    const subs = await user.notification.subscribe(PUSH_PROTOCOL_CHANNEL.caip)

    return reply.code(200).send(subs.message)
  })

  // TODO: Send notification to user with Push Protocol, params: walletAddress[] + notif payload (title, body, screen)
  server.post('/send-notification', async (request, reply) => {
    try {
      const { walletAddresses, notificationPayload } = request.body;

      await validateRequiredFields(request.body, ['walletAddresses', 'notificationPayload'], reply);

      const users = await prismaClient.userNotification.findMany({
        where: {
          walletAddress: {
            in: walletAddresses
          }
        }
      })

      if (users.length === 0) {
        return reply.code(404).send({ message: 'No user found' });
      }

      const wallet = new ethers.Wallet(process.env.PUSH_PROTOCOL_SECRET_KEY);
      const admin = await PushAPI.initialize(wallet, {
        env: 'prod'
      });

      const addresses = users.map(user => user.walletAddress);
      console.log('addresses', addresses)
      const sendNotification = await admin.channel.send(addresses, {
        notification: {
          title: notificationPayload.title,
          body: notificationPayload.body,
        },
        channel: PUSH_PROTOCOL_CHANNEL.caip
      })

      for (let i = 0; i < users.length; i++) {
        await sendFirebaseNotification(users[i].fcmToken, notificationPayload);
      }

      return reply.code(200).send("Notification sent");
    } catch (error) {
      console.error('An error occurred:', error);
      return reply.code(500).send({ message: error });
    }
  })


  // TODO: Send notification to user with Firebase, using fcmToken
  const sendFirebaseNotification = async (fcmToken, notificationPayload) => {
    try {
      console.log({
        fcmToken,
        notificationPayload
      })

      const res = await axios({
        method: 'POST',
        url: 'https://fcm.googleapis.com/fcm/send',
        headers: {
          Authorization: `key=${process.env.FIREBASE_AUTH}`,
        }
      })

      console.log('res', res.data)
    } catch (error) {
      console.error('sendFirebaseNotification', error);
    }
  }

  // let channelAdmin = null;
  // const getChannelAdmin = async () => {
  //   if (channelAdmin) {
  //     return channelAdmin;
  //   }

  //   const PRIVATE_KEY = process.env.PRIVATE_KEY;
  //   const wallet = new ethers.Wallet(PRIVATE_KEY);
  //   channelAdmin = await PushAPI.initialize(wallet, {
  //     env: 'prod'
  //   });


  //   const channel = await channelAdmin.channel.info(process.env.PUSH_PROTOCOL_CHANNEL)
  //   console.log('channel', channel)

  //   return channelAdmin;
  // }

  // getChannelAdmin();
}