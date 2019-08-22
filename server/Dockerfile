FROM node:latest

Run mkdir -p /ttp5-luckyshop-xianlin.dong
WORKDIR /ttp5-luckyshop-xianlin.dong

COPY . /ttp5-luckyshop-xianlin.dong
RUN npm install

ENV NODE_ENV=production
ENV HOST 0.0.0.0

EXPOSE 7001

CMD ["npm", "start" ]