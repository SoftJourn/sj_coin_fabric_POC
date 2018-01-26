FROM node:6
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app

RUN mkdir -p "/app_data/fabric-client-kvs_peerCoins1" && chmod -R 777 "/app_data"

ENTRYPOINT node app.js
EXPOSE 4000