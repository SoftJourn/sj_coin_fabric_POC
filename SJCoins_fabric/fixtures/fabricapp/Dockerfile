FROM node:6

WORKDIR /app

RUN git clone -v https://github.com/SoftJourn/sj_coin_fabric_POC.git

WORKDIR /app/sj_coin_fabric_POC/SJCcoins_app/

RUN npm install

ENTRYPOINT npm start

EXPOSE 4200