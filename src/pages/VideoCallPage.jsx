import * as PushAPI from '@pushprotocol/restapi'
import { ethers } from 'ethers'
import React, { useEffect, useRef, useState } from 'react'
import { produce } from 'immer';
import { usePushSocket } from '../hooks/usePushSockets';
import { ADDITIONAL_META_TYPE } from '@pushprotocol/restapi/src/lib/payloads';
import VideoPlayer from '../components/VideoPlayer';
import { useSearchParams } from 'react-router-dom';

export default function VideoCallPage() {
  const [params, setParams] = useSearchParams()
  const wallet = new ethers.Wallet(params.get('pkpg'))
  console.log({
    address: wallet.address
  })

  const { pushSocket, isPushSocketConnected, latestFeedItem } = usePushSocket()

  const videoObjectRef = useRef();
  const recipientAddressRef = useRef();
  const chatIdRef = useRef();

  const [data, setData] = useState(PushAPI.video.initVideoCallData)

  const initialize = async () => {
    // const provider = await ethers.providers.JsonRpcProvider(import.meta.env.VITE_INFURA_API_KEY)

    // PushAPI

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

  useEffect(() => {
    initialize()
  }, [])

  // Accept the video call
  const acceptVideoCallRequest = async () => {
    if (!data.local.stream) return;

    await videoObjectRef.current?.acceptRequest({
      signalData: data.meta.initiator.signal,
      senderAddress: data.local.address,
      recipientAddress: data.incoming[0].address,
      chatId: data.meta.chatId,
    })
  }

  const connectHandler = (videoCallMetaData) => {
    videoObjectRef.current?.connect({
      signalData: videoCallMetaData.signalData,
    })
  }

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

  // establish the connection
  useEffect(() => {
    if (!pushSocket?.connected) {
      pushSocket?.connect()
    }
  }, [pushSocket])

  // receive video call notifications
  useEffect(() => {
    if (!isPushSocketConnected || !latestFeedItem) return;

    const { payload } = latestFeedItem || {};

    // check for additionalMeta
    if (
      !Object.prototype.hasOwnProperty.call(payload, 'data') ||
      !Object.prototype.hasOwnProperty.call(payload["data"], 'additionalMeta')
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

  const setRequestVideoCall = async () => {
    videoObjectRef.current?.setData((oldData) => {
      return produce(oldData, (draft) => {
        if (!recipientAddressRef || !recipientAddressRef.current) return;
        if (!chatIdRef || !chatIdRef.current) return;

        draft.local.address = wallet.address;
        draft.incoming[0].address = recipientAddressRef.current.value;
        draft.incoming[0].status = PushAPI.VideoCallStatus.INITIALIZED;
        draft.meta.chatId = chatIdRef.current.value;
      })
    })

    // Start the local media stream
    await videoObjectRef.current?.create({
      video: true,
      audio: true,
    })
  }

  const setIncomingVideoCall = async (videoCallMetaData) => {
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
  }


  return (
    <div className='container mx-auto max-w-lg bg-white min-h-screen py-16 px-4'>
      <div className='text-black text-2xl'>VideoCallPage</div>

      <div className='mt-2'>
        Connected address: {wallet.address}
      </div>

      <div className='flex flex-col gap-4 my-4 border border-black/10 p-4'>
        <div className='flex flex-col'>
          <label htmlFor='recipientAddress'>Recipient Address</label>
          <input className='input input-bordered'
            ref={recipientAddressRef}
            placeholder='Enter recipient address'
            type='text'
          />
        </div>

        <div className='flex flex-col'>
          <label htmlFor='chatId'>Chat id</label>
          <input className='input input-bordered'
            ref={chatIdRef}
            placeholder='Enter chat id'
            type='text'
          />
        </div>
      </div>

      <div className='flex flex-row flex-wrap gap-2 mt-2'>
        <button className='btn btn-primary'
          disabled={data.incoming[0].status !== PushAPI.VideoCallStatus.UNINITIALIZED}
          onClick={setRequestVideoCall}
        >
          Request
        </button>

        <button className='btn btn-primary'
          disabled={data.incoming[0].status !== PushAPI.VideoCallStatus.RECEIVED}
          onClick={acceptVideoCallRequest}
        >
          Accept Request
        </button>

        <button className='btn btn-error'
          disabled={data.incoming[0].status === PushAPI.VideoCallStatus.UNINITIALIZED}
          onClick={() => videoObjectRef.current?.disconnect()}
        >
          Disconnect
        </button>

        <button className='btn btn-primary'
          disabled={data.incoming[0].status === PushAPI.VideoCallStatus.UNINITIALIZED}
          onClick={() => {
            videoObjectRef.current?.enableVideo({
              state: !data.local.video
            })
          }}
        >
          Toggle Video
        </button>


        <button className='btn btn-primary'
          disabled={data.incoming[0].status === PushAPI.VideoCallStatus.UNINITIALIZED}
          onClick={() => {
            videoObjectRef.current?.enableAudio({
              state: !data.local.audio
            })
          }}
        >
          Toggle Audio
        </button>
      </div>

      <div className='flex flex-col'>
        <p>
          LOCAL VIDEO: {data.local.video ? 'ON' : 'OFF'}
        </p>
        <p>
          LOCAL AUDIO: {data.local.audio ? 'ON' : 'OFF'}
        </p>
        <p>
          INCOMING VIDEO: {data.incoming[0].video ? 'ON' : 'OFF'}
        </p>
        <p>
          INCOMING AUDIO: {data.incoming[0].audio ? 'ON' : 'OFF'}
        </p>
      </div>

      <div className='mt-8'>
        <div className='bg-white p-2 shadow-md border border-black/10 rounded-md flex flex-col divide-y-2 divide-black'>
          <div className='py-2'>
            <h2>
              Local Video
            </h2>
            <VideoPlayer stream={data.local.stream} />
          </div>

          <div className='py-2'>
            <h2>
              Incoming Video
            </h2>
            <VideoPlayer stream={data.local.stream} />
          </div>
        </div>
      </div>
    </div>
  )
}
