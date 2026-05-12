FROM node:14 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:14
WORKDIR /app
COPY --from=build /app/build/ /app/
COPY --from=build /app/package*.json ./
RUN npm install
RUN groupadd -r node && useradd -r -g node node
USER node
EXPOSE 80
CMD ["npm", "start"]