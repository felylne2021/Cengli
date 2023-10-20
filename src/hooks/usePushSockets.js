import { ethers } from 'ethers'
import React, { useEffect, useState } from 'react'
import { useParams, useSearchParams } from 'react-router-dom'
import { createSocketConnection, EVENTS } from '@pushprotocol/socket'

export const usePushSocket = () => {
  const [params, setParams] = useSearchParams()
  const pkpg = params.get('pkpg')
  const wallet = new ethers.Wallet(pkpg)

  const [pushSocket, setPushSocket] = useState(null)
  const [latestFeedItem, setLatestFeedItem] = useState(null)
  const [isPushSocketConnected, setIsPushSocketConnected] = useState(
    pushSocket?.connected
  )

  const addSocketEvents = () => {
    pushSocket?.on(EVENTS.CONNECT, () => {
      console.log('connected')
      setIsPushSocketConnected(true)
    })

    pushSocket?.on(EVENTS.DISCONNECT, () => {
      console.log('disconnected')
      setIsPushSocketConnected(false)
      setLatestFeedItem([])
    })

    pushSocket?.on(EVENTS.USER_FEEDS, (feedItem) => {
      console.log('feedItem', feedItem)
      setLatestFeedItem(feedItem)
    })
  }

  const removeSocketEvents = () => {
    pushSocket?.off(EVENTS.CONNECT)
    pushSocket?.off(EVENTS.DISCONNECT)
    pushSocket?.off(EVENTS.USER_FEEDS)
  }

  useEffect(() => {
    if (pushSocket) {
      addSocketEvents()
    }

    return () => {
      if (pushSocket) {
        removeSocketEvents()
      }
    }
  }, [pushSocket])

  useEffect(() => {
    if (wallet.address) {
      if (pushSocket) {
        pushSocket?.disconnect()
      }

      const connectionObject = createSocketConnection({
        user: `eip155:1:${wallet.address}`,
        env: 'prod',
        socketOptions: {
          autoConnect: false
        }
      })
      setPushSocket(connectionObject)
    }
  }, [wallet.address])

  return {
    pushSocket,
    isPushSocketConnected,
    latestFeedItem,
  }
}