import React, { useEffect, useRef } from 'react'

export default function VideoPlayer({
  stream
}) {
  const videoRef = useRef()

  useEffect(() => {
    if(videoRef.current){
      videoRef.current.srcObject = stream
      videoRef.current.play()
    }
  }, [videoRef, stream])

  return (
    <video
      ref={videoRef}
      className='w-full h-full object-cover'
      autoPlay
      playsInline
      muted
    />
  )
}
