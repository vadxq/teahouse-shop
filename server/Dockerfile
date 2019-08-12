FROM node:latest

Run mkdir -p /teahouse_shop
WORKDIR /teahouse_shop

COPY . /teahouse_shop
RUN npm install

ENV NODE_ENV=production
ENV HOST 0.0.0.0

EXPOSE 7001

CMD ["npm", "start" ]