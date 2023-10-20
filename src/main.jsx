// import './polyfills'

import React from 'react'
import ReactDOM from 'react-dom/client'

import './styles/index.scss'

import { RouterProvider } from 'react-router-dom'
import { router } from './routes/index';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <div className='bg-primary-200'>
      <RouterProvider router={router} />
    </div>
  </React.StrictMode>,
)
