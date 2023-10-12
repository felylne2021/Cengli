FROM node:lts-alpine

ENV NODE_ENV=production
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent

# Generate Prisma Client
RUN npx prisma generate

# Copy other project files
COPY . .

# Expose the port the app runs on
EXPOSE 3001

# Change ownership and switch user
RUN chown -R node /usr/src/app
USER node

CMD ["npm", "start"]
