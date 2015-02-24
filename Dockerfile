FROM ubuntu
Maintainer Sebastian Kornehl <sebastian.kornehl@asideas.de>

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_ENV production
ENV NODE_VERSION 0.11.9
ENV NODE_PATH /root/v$(NODE_VERSION)/bin

# preq
RUN apt-get update 
RUN apt-get install -y curl

# ADD Repos
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -

# INSTALL
RUN apt-get update 
RUN apt-get install -y adduser python build-essential libssl-dev mongodb-org python-pip python-dev

RUN pip install ansible

COPY . /root/

WORKDIR /root/

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh 
RUN cat ~/.nvm/nvm.sh >> installnode.sh
RUN echo "nvm install $NODE_VERSION " >> installnode.sh
RUN sh installnode.sh

ENV PATH /root/v$NODE_VERSION/bin:$PATH
RUN npm install -g gulp bower && npm install && bower install && npm run build

CMD ./start-app.js
