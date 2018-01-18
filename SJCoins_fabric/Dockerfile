FROM node:6
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app

RUN mkdir -p "/tmp/fabric-client-kvs_peerCoins" && chmod -R 777 "/tmp"

ENTRYPOINT node app.js
EXPOSE 4000