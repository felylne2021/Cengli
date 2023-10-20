import React, { useEffect } from 'react'
import { Outlet } from 'react-router-dom'

export default function MainLayout({ children }) {
  useEffect(() => {
    if (window.crypto && window.crypto.subtle) {
      console.log('Web Crypto API is supported.');
    } else {
      console.error('Web Crypto API is not supported.');
    }
  }, []);

  return (
    <div className='min-h-screen'>
      <Outlet />
    </div>
  )
}
