# Define which Ubuntu version to run
FROM ubuntu:20.04

# Basic components needed
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y make gcc "g++"
RUN apt-get install -y libxml2-dev curl

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs

# Home directory for Node-RED application source code.
RUN mkdir -p /usr/src/node-red

# User data directory, contains flows, config and nodes.
RUN mkdir /data

WORKDIR /usr/src/node-red

# Add node-red user so we aren't running as root.
RUN adduser --home /usr/src/node-red --gecos "" --disabled-password --no-create-home node-red
RUN  chown -R node-red /data \
    && chown -R node-red /usr/src/node-red
RUN  chgrp -R node-red /data \
    && chgrp -R node-red /usr/src/node-red

USER node-red

RUN node --version
RUN npm --version

# package.json contains Node-RED NPM module and node dependencies
COPY package.json /usr/src/node-red/
RUN npm install

COPY flows.json /data/flows.json
#COPY start-up.sh /data/start-up.sh
#COPY settings.js /data/settings.js

# User configuration directory volume
#VOLUME ["/data"]
EXPOSE 1880

# Environment variable holding file path for flows configuration
#ENV FLOWS=flows.json

#CMD ["npm", "start", "--", "--userDir", "/data"]

#ENTRYPOINT [ "/bin/bash", "/data/start-up.sh" ]

#EXPOSE 1880
