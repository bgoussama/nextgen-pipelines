FROM node:14 as builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM node:14

WORKDIR /app

COPY --from=builder /app/build/ /app/

RUN groupadd -r node && useradd -r -g node node

USER node

EXPOSE 80

CMD ["npm", "start"]
