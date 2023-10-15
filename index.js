import dotenv from 'dotenv';
dotenv.config();

import path from 'path';
import { fileURLToPath } from 'url';

import Fastify from 'fastify';
import fastifyCors from '@fastify/cors'
import fastifyStatic from '@fastify/static'

import { dataWorker } from './workers/dataWorker.js';
import { partnerWorker } from './workers/partnerWorker.js';

import { accountRoutes } from './routes/accountRoutes.js';
import { transferRoutes } from './routes/transferRoutes.js';
import { infoRoutes } from './routes/infoRoutes.js';
import { docs } from './routes/docs.js';
import { p2pRoutes } from './routes/p2pRoutes.js';


const fastify = Fastify({ logger: false });

fastify.register(fastifyCors, {
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
});


const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
fastify.register(fastifyStatic, {
  root: path.join(__dirname, 'public'),
});


fastify.get('/check', async () => {
  return { message: "Cengli Backend ✌️" }
})

// Workers
fastify.register(dataWorker);
fastify.register(partnerWorker)

// Routes
fastify.register(accountRoutes, {
  prefix: '/account'
});

fastify.register(transferRoutes, {
  prefix: '/transfer'
});

fastify.register(infoRoutes, {
  prefix: '/info'
});

fastify.register(p2pRoutes, {
  prefix: '/p2p'
})

// Docs
fastify.register(docs, {
  prefix: '/docs'
})


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