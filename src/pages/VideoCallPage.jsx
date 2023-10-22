import React, { useEffect, useState } from 'react'
import * as PushAPI from '@pushprotocol/restapi'
import { useSearchParams } from 'react-router-dom';

import VideoPlayer from '../components/VideoPlayer';
import useVideoCall from '../hooks/useVideoCall';
import { ethers } from 'ethers';
import axios from 'axios';

export default function VideoCallPage() {
  const [params] = useSearchParams()
  const pkpg = params.get('pkpg')

  // connect user and admin chat through backend, then use the chatId for the rest of the code
  const [chatId, setChatId] = useState('')
  const [adminAddress, setAdminAddress] = useState('')
  const [userAddress, setUserAddress] = useState('')

  const connectChat = async () => {
    const connectChatRes = await axios({
      method: 'POST',
      url: `${import.meta.env.VITE_BACKEND_URL}/push-protocol/connect-chat`,
      data: {
        pkpg: pkpg
      }
    })

    console.log('connectChatRes', connectChatRes)
    setChatId(connectChatRes.data.chatId)
    setAdminAddress(connectChatRes.data.admin)
    setUserAddress(connectChatRes.data.user)
  }

  useEffect(() => {
    connectChat()
  }, [])

  if (chatId && adminAddress && userAddress) {
    return <VideoCall pkpg={pkpg} chatId={chatId} adminAddress={adminAddress} />
  }

  return (
    <div className='bg-white w-screen h-screen flex flex-col justify-center items-center'>
      <div className='flex flex-col max-w-[20rem] text-center break-all text-xs animate-fade-up'>
        <div>
          <span className="loading loading-spinner bg-primary loading-lg"></span>
        </div>

        <h2 className='mt-5 text-lg animate-bounce'>
          Initializing KYC Session...
        </h2>
      </div>
    </div>
  )
}


export const VideoCall = ({
  pkpg,
  chatId,
  adminAddress,
}) => {
  const { wallet, data, setRequestVideoCall, acceptVideoCallRequest, videoObjectRef, isLoading, isPushSocketConnected } = useVideoCall({
    chatId: chatId,
    pkpg: pkpg,
    recipientAddress: adminAddress
  })

  if (!data.local.stream && !data.incoming[0].stream) {
    return (
      <div className='bg-white w-screen h-screen flex flex-col justify-center items-center'>
        <button className={`btn btn-primary ${isLoading ? 'animate-pulse' : ''}`}
          onClick={setRequestVideoCall}
          disabled={isLoading}
        >
          Start KYC Session
        </button>

        {/* <div className='flex flex-col max-w-[12rem] text-center break-all text-xs mt-10'>
          <p>
            recipientAddress:<br /> {adminAddress}
          </p>
          <br />
          <p>
            chatId:<br /> {chatId}
          </p>
        </div> */}
      </div>
    )
  }

  return (
    <div className='flex flex-row'>
      <div className='container mx-auto max-w-2xl bg-white min-h-screen'>
        <div className='w-full h-full relative'>
          {/* Self */}
          <div className='bg-white w-full h-full z-0'>
            <VideoPlayer stream={data.local.stream} muted />
          </div>

          {/* Caller */}
          <div className='absolute top-[3rem] right-[1rem] w-[35%] rounded-xl overflow-hidden shadow-lg'
            style={{ aspectRatio: '3/4' }}
          >
            {!data.incoming[0].stream ?
              <div className='bg-white animate-pulse w-full h-full flex flex-col justify-center items-center'>
                <span className="loading loading-spinner loading-lg"></span>
              </div>
              :
              <VideoPlayer stream={data.incoming[0].stream} className='bg-slate-400 animate-jump' />
            }
          </div>

          <div className='bottom-[2rem] absolute w-full'>
            <div className='flex flex-row items-center justify-center gap-[4rem]'>
              {/* Mute/unmute */}
              <button
                onClick={() => videoObjectRef.current?.enableAudio({
                  state: !data.local.audio
                })}
                className='btn btn-white aspect-square w-[3rem] h-[3rem] p-2 rounded-full'
              >
                {data.local.audio ?
                  <img src={"/icon_mute.svg"} alt="Mute" />
                  :
                  <img src={"/icon_muted.svg"} alt="Unmute" />
                }
              </button>

              <button
                onClick={async () => {
                  await videoObjectRef.current?.disconnect()
                  window.flutter_inappwebview.callHandler('callHandler', 'completed');
                }}
                className='btn btn-error aspect-square w-[4rem] h-[4rem] p-2 rounded-full'
              >
                <img src={"/icon_hang_up.svg"} alt="DC" />
              </button>

              {/* Change Cameras */}
              <button className='btn btn-white aspect-square w-[3rem] h-[3rem] rounded-full opacity-0 pointer-events-none'>
                Yee
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}