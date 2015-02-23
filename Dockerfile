FROM debian
Maintainer Sebastian Kornehl <sebastian.kornehl@asideas.de>

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_ENV roduction

# preq
RUN apt-get update 
RUN apt-get install -y curl

# ADD Packages
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

# INSTALL
RUN apt-get update 
RUN apt-get install -y adduser python nodejs mongodb-org python-pip

RUN pip install ansible

COPY . /root/

WORKDIR /root/
 
RUN npm install -g gulp bower && npm install && bower install && npm run build

CMD ./start-app.js
