import React from 'react'
import * as PushAPI from '@pushprotocol/restapi'
import { useSearchParams } from 'react-router-dom';

import VideoPlayer from '../components/VideoPlayer';
import useVideoCall from '../hooks/useVideoCall';

export default function VideoCallPage() {
  const [params] = useSearchParams()
  const pkpg = params.get('pkpg')
  const recipientAddress = params.get('recipientAddress')
  const chatId = params.get('chatId')
  const isAdminSide = params.get('isAdminSide') || 'false'

  if ((!pkpg || !recipientAddress || !chatId) && isAdminSide === 'false') {
    return 'User side: params are not complete, please add pkpg, recipientAddress, chatId'
  }

  if ((!pkpg) && isAdminSide === 'true') {
    return 'Admin side: params are not complete, please add pkpg'
  }

  const { wallet, data, setRequestVideoCall, acceptVideoCallRequest, videoObjectRef, isLoading } = useVideoCall({
    chatId: chatId,
    pkpg: pkpg,
    recipientAddress: recipientAddress,
  })

  if (!data.local.stream && !data.incoming[0].stream) {
    return (
      <div className='bg-white w-screen h-screen flex flex-col justify-center items-center'>
        <button className={`btn btn-primary ${isLoading ? 'animate-pulse' : ''}`}
          onClick={setRequestVideoCall}
          disabled={isLoading}
        >
          Start Video Call
        </button>

        <div className='flex flex-col max-w-[12rem] text-center break-all text-xs mt-10'>
          <p>
            recipientAddress:<br /> {recipientAddress}
          </p>
          <br />
          <p>
            chatId:<br /> {chatId}
          </p>
        </div>
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
                onClick={() => videoObjectRef.current?.disconnect()}
                className='btn btn-error aspect-square w-[4rem] h-[4rem] p-2 rounded-full'
              >
                <img src={"/icon_hang_up.svg"} alt="DC" />
              </button>

              {/* Change Cameras */}
              <button className='btn btn-white aspect-square w-[3rem] h-[3rem] rounded-full'>
                Yee
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* <div>
        <div className='text-black text-2xl'>VideoCallPage</div>

        <div className='mt-2'>
          Connected address: {wallet.address}
        </div>

        <div className='flex flex-col gap-4 my-4 border border-black/10 p-4'>
          <div className='flex flex-col'>
            <label htmlFor='recipientAddress'>Recipient Address</label>
            <div>
              {recipientAddress}
            </div>
          </div>

          <div className='flex flex-col'>
            <label htmlFor='chatId'>Chat id</label>
            <div>
              {chatId}
            </div>
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
              <VideoPlayer stream={data.incoming[0].stream} />
            </div>
          </div>
        </div>
      </div> */}
    </div>
  )
}
