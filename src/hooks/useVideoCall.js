import { useState, useEffect, useRef } from 'react';
import { ethers } from 'ethers';
import { produce } from 'immer';
import { usePushSocket } from './usePushSockets';
import * as PushAPI from '@pushprotocol/restapi'
import { ADDITIONAL_META_TYPE } from '@pushprotocol/restapi/src/lib/payloads';

export default function useVideoCall({
  pkpg,
  recipientAddress,
  chatId,
}) {
  const wallet = new ethers.Wallet(pkpg);
  const { pushSocket, isPushSocketConnected, latestFeedItem } = usePushSocket();
  const videoObjectRef = useRef();
  const [data, setData] = useState(PushAPI.video.initVideoCallData);

  const initialize = async () => {
    const user = await PushAPI.PushAPI.initialize(wallet, {
      env: 'prod'
    })

    console.log({
      user,
      pgpPrivateKey: user.decryptedPgpPvtKey
    })

    videoObjectRef.current = new PushAPI.video.Video({
      signer: wallet,
      chainId: 1,
      pgpPrivateKey: user.decryptedPgpPvtKey,
      env: 'prod',
      setData: setData
    })
  }

  const connectHandler = (videoCallMetaData) => {
    videoObjectRef.current?.connect({
      signalData: videoCallMetaData.signalData,
    })
  }

  // Accept the video call
  const acceptVideoCallRequest = async () => {
    if(isLoading) return;

    setIsLoading(true)

    if (!data.local.stream) return;

    await videoObjectRef.current?.acceptRequest({
      signalData: data.meta.initiator.signal,
      senderAddress: data.local.address,
      recipientAddress: data.incoming[0].address,
      chatId: data.meta.chatId,
    })

    setIsLoading(false)
  }

  const [isLoading, setIsLoading] = useState(false)

  const setRequestVideoCall = async () => {
    if (isLoading) return;

    setIsLoading(true)
    videoObjectRef.current?.setData((oldData) => {
      return produce(oldData, (draft) => {
        if (!recipientAddress) return;
        if (!chatId) return;

        draft.local.address = wallet.address;
        draft.incoming[0].address = recipientAddress;
        draft.incoming[0].status = PushAPI.VideoCallStatus.INITIALIZED;
        draft.meta.chatId = chatId;
      })
    })

    // Start the local media stream
    await videoObjectRef.current?.create({
      video: true,
      audio: true,
    })

    setIsLoading(false)
  }

  const setIncomingVideoCall = async (videoCallMetaData) => {
    if (isLoading) return;

    setIsLoading(true)

    videoObjectRef.current?.setData((oldData) => {
      return produce(oldData, (draft) => {
        draft.local.address = videoCallMetaData.recipientAddress;
        draft.incoming[0].address = videoCallMetaData.senderAddress;
        draft.incoming[0].status = PushAPI.VideoCallStatus.RECEIVED;
        draft.meta.chatId = videoCallMetaData.chatId;
        draft.meta.initiator.address = videoCallMetaData.senderAddress;
        draft.meta.initiator.signal = videoCallMetaData.signalData;
      })
    })

    // Start the local media stream
    await videoObjectRef.current?.create({
      video: true,
      audio: true,
    })

    setIsLoading(false)
  }

  useEffect(() => {
    initialize();
  }, []);

  // after setRequestVideoCall, if local stream is ready, fire the request()
  useEffect(() => {
    (async () => {
      const currentStatus = data.incoming[0].status;

      if (
        data.local.stream &&
        currentStatus === PushAPI.VideoCallStatus.INITIALIZED
      ) {
        await videoObjectRef.current?.request({
          senderAddress: wallet.address,
          recipientAddress: data.incoming[0].address,
          chatId: data.meta.chatId,
        })
      }
    })()
  }, [data.incoming, data.local.address, data.local.stream, data.meta.chatId])

  useEffect(() => {
    if (!pushSocket?.connected) {
      pushSocket?.connect()
    }
  }, [pushSocket])

  // receive video call notifications
  useEffect(() => {
    console.log('latestFeedItem', latestFeedItem)

    if (!isPushSocketConnected || !latestFeedItem) return;

    const { payload } = latestFeedItem || {};

    // check for additionalMeta
    if (
      // eslint-disable-next-line no-prototype-builtins
      !payload.hasOwnProperty('data') ||
      // eslint-disable-next-line no-prototype-builtins
      !payload['data'].hasOwnProperty('additionalMeta')
    ) return;

    const additionalMeta = payload["data"]["additionalMeta"];
    console.log('received additionalMeta', additionalMeta)
    if (!additionalMeta) return;

    if (additionalMeta.type !== `${ADDITIONAL_META_TYPE.PUSH_VIDEO}+1`) return;
    const videoCallMetaData = JSON.parse(additionalMeta.data);
    console.log('received video data', videoCallMetaData)

    if (videoCallMetaData.status === PushAPI.VideoCallStatus.INITIALIZED) {
      setIncomingVideoCall(videoCallMetaData)
    } else if (
      videoCallMetaData.status === PushAPI.VideoCallStatus.RECEIVED ||
      videoCallMetaData.status === PushAPI.VideoCallStatus.RETRY_RECEIVED
    ) {
      connectHandler(videoCallMetaData)
    } else if (
      videoCallMetaData.status === PushAPI.VideoCallStatus.DISCONNECTED
    ) {
      window.location.reload()
    } else if (
      videoCallMetaData.status === PushAPI.VideoCallStatus.RETRY_INITIALIZED &&
      videoObjectRef.current?.isInitiator()
    ) {
      videoObjectRef.current?.request({
        senderAddress: wallet.address,
        recipientAddress: data.incoming[0].address,
        chatId: data.meta.chatId,
        retry: true,
      })
    } else if (
      videoCallMetaData.status === PushAPI.VideoCallStatus.RETRY_INITIALIZED &&
      !videoObjectRef.current?.isInitiator()
    ) {
      videoObjectRef.current?.acceptRequest({
        signalData: videoCallMetaData.signalData,
        senderAddress: data.local.address,
        recipientAddress: data.incoming[0].address,
        chatId: data.meta.chatId,
        retry: true,
      })
    }
  }, [latestFeedItem])

  return {
    wallet,
    data,
    setRequestVideoCall,
    acceptVideoCallRequest,
    videoObjectRef,
    isPushSocketConnected,
    isLoading,
  };
}
