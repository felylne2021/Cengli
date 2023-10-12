FROM node:lts-alpine

ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
RUN chown -R node /usr
USER node
COPY . .
EXPOSE 3001

CMD ["npm", "start"]
