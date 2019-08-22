FROM node:latest

Run mkdir -p /teahouse
WORKDIR /teahouse

COPY . /teahouse
RUN npm install

EXPOSE 7001

CMD ["npm", "start" ]