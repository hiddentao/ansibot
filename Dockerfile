FROM ubuntu
Maintainer Sebastian Kornehl <sebastian.kornehl@asideas.de>

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_ENV production
ENV NODE_VERSION 0.12.0
ENV NODE_PATH /root/.nvm/versions/node/v$NODE_VERSION/bin

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
RUN apt-get install -y adduser python build-essential libssl-dev mongodb-org python-pip python-dev git

RUN pip install ansible

WORKDIR /root/
COPY . /root/

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.23.3/install.sh | sh 
RUN cat ~/.nvm/nvm.sh >> installnode.sh
RUN echo "nvm install $NODE_VERSION " >> installnode.sh
RUN echo "nvm which $NODE_VERSION " >> installnode.sh
RUN sh installnode.sh

ENV PATH /root/versions/node/v0.12.0/bin:$NODE_PATH:$PATH
RUN npm install -g gulp bower 
RUN npm install
RUN bower --allow-root install 
RUN npm run build

CMD ./start-app.js
