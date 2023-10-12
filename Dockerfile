FROM node:lts-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../

# Generate Prisma Client
RUN npx prisma generate

COPY ./prisma prisma

COPY . .
EXPOSE 3001
RUN chown -R node /usr/src/app
USER node
CMD ["node", "index.js"]
