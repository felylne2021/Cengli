import dotenv from 'dotenv';
dotenv.config();

import Fastify from 'fastify';
import fastifyCors from '@fastify/cors'

import { dataWorker } from './workers/dataWorker.js';

import { accountRoutes } from './routes/accountRoutes.js';
import { transferRoutes } from './routes/transferRoutes.js';

const fastify = Fastify({ logger: false });

fastify.register(fastifyCors, {
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
});

fastify.get('/check', async (request, reply) => {
  return { message: "Cengli Backend ✌️" }
})

// Workers
fastify.register(dataWorker);

// Routes
fastify.register(accountRoutes, {
  prefix: '/account'
});

fastify.register(transferRoutes, {
  prefix: '/transfer'
});

const start = async () => {
  try {
    const port = process.env.APP_PORT || 3001;
    await fastify.listen({
      port: port,
      host: '0.0.0.0'
    })

    console.log(`Server is listening on port http://localhost:${fastify.server.address().port}`);
  } catch (error) {
    console.log('Error starting server: ', error);
    process.exit(1);
  }
};

start();