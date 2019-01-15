FROM ubuntu:latest

RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  openjdk-8-jdk \
  wget \
  curl \
  expect \
  zip \
  unzip \
  gnupg \
  make \
  g++ \
  python2.7 \
  python-pip \
  && rm -rf /var/lib/apt/lists/*

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.12.0
RUN mkdir -p /usr/local/nvm
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
RUN source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN npm i -g yarn
RUN yarn global add react-native-cli

RUN cd /opt
RUN mkdir android-sdk-linux && cd android-sdk-linux/
RUN wget https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
RUN unzip tools_r25.2.3-linux.zip -d /opt/android-sdk-linux
RUN rm -rf tools_r25.2.3-linux.zip
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}
RUN echo y | android update sdk --no-ui --all --filter platform-tools
RUN echo y | android update sdk --no-ui --all --filter android-25
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.2
RUN touch /root/.android/repositories.cfg
RUN echo y | sdkmanager --update --verbose
RUN apt-get clean
RUN chown -R 1000:1000 $ANDROID_HOME
