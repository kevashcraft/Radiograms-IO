FROM node:12.3.1-stretch as builder

RUN npm i -g @vue/cli

RUN mkdir -p /app
WORKDIR /app

COPY app/package*.json ./
RUN npm ci

COPY app/babel.config.js .
COPY app/vue.config.js .
COPY app/public public
COPY app/src src

RUN npm run build

FROM nginx:1.13

COPY build/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
