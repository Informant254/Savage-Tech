FROM node:20-bookworm-slim

WORKDIR /usr/src/app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm install --omit=dev --no-audit --no-fund

COPY --chown=node:node . .
USER node

CMD ["node", "server.js"]
