import React from "react";
import { createBrowserRouter } from "react-router-dom";
import MainLayout from "../layouts/MainLayout";

import VideoCallPage from "../pages/VideoCallPage";
import AdminVideoCallPage from "../pages/AdminVideoCallPage";

export const router = createBrowserRouter([
  {
    path: '/',
    element: <MainLayout />,
    children: [
      {
        path: 'video-call',
        element: <VideoCallPage />
      },
      {
        path: 'admin-video-call',
        element: <AdminVideoCallPage />
      }
    ]
  }
])