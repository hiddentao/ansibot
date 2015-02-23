FROM debian
Maintainer Sebastian Kornehl <sebastian.kornehl@asideas.de>

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_ENV roduction

# INSTALL NODE
RUN apt-get update 
RUN apt-get install -y curl 
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs

COPY . /root/

WORKDIR /root/
 
RUN npm install -g gulp bower && npm install && bower install && npm run build

CMD ./start-app.js
