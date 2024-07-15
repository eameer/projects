# Build Stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --production

EXPOSE 4004

CMD ["npm", "run", "serve"]
