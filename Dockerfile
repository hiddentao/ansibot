FROM ubuntu
Maintainer Sebastian Kornehl <sebastian.kornehl@asideas.de>

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_ENV production
ENV NODE_VERSION 0.12.0
ENV NODE_PATH /root/versions/node/v$NODE_VERSION/bin
ENV PATH $NODE_PATH:$PATH

# preq
RUN apt-get update && apt-get install -y curl sudo

# ADD Repos
RUN curl -sL https://deb.nodesource.com/setup | bash - && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
    echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

# INSTALL
RUN apt-get update && \
    apt-get install -y adduser python build-essential libssl-dev mongodb-org python-pip python-dev git &&\ 
    pip install ansible

RUN mkdir -p /data/db

WORKDIR /root/
COPY . /root/

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.23.3/install.sh | sh &&\
    cat ~/.nvm/nvm.sh >> installnode.sh &&\
    echo "nvm install $NODE_VERSION " >> installnode.sh &&\
    sh installnode.sh

RUN npm install -g gulp bower &&\
    npm install &&\
    bower --allow-root install &&\
    npm run build  &&\
    sed -i "s"#"\/usr\/bin\/env node#$NODE_PATH/node#g" start-app.js

VOLUME ["/playbooks"]
EXPOSE 3000

# CLEANUP
RUN rm -rf /tmp/* &&\
    apt-get autoremove -qq &&\
    rm -rf /var/lib/apt/lists/*

CMD service mongod start && ./start-app.js
