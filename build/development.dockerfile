FROM node:12.3.1-stretch as builder

RUN npm i -g @vue/cli cordova

RUN \
apt-get update && \
apt-get install -y default-jdk-headless gradle android-sdk
#  && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
  git clone https://github.com/Shadowstyler/android-sdk-licenses.git && \
  cp -a android-sdk-licenses/*-license /usr/lib/android-sdk/licenses && \
  rm -rf android-sdk-licenses

RUN mkdir -p /app
WORKDIR /app

COPY app/package.json ./
COPY app/package-lock.json ./
RUN npm ci

COPY app/babel.config.js .
COPY app/vue.config.js .
COPY app/public public
COPY app/src src

CMD ["npm", "run", "serve"]
