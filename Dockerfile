FROM node:18-alpine
RUN npm install --global npm@latest
RUN apk add --no-cache git
RUN adduser --disabled-password --no-create-home appuser && USER appuser
EXPOSE 8080
CMD ["node", "-e", "require('http').createServer((req,res)=>{res.end('OK')}).listen(8080)"]