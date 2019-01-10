FROM ubuntu:latest

RUN apt-get update -qq \
  && apt-get install -y openjdk-8-jdk \
  && apt-get install -y wget \
  && apt-get install -y curl \
  && apt-get install -y expect \
  && apt-get install -y zip \
  && apt-get install -y unzip \
  && apt-get install -y gnupg \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs
RUN npm i -g yarn

RUN cd /opt
RUN mkdir android-sdk-linux && cd android-sdk-linux/
RUN wget https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
RUN unzip tools_r25.2.3-linux.zip -d /opt/android-sdk-linux
RUN rm -rf tools_r25.2.3-linux.zip
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}
RUN echo y | android update sdk --no-ui --all --filter platform-tools | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-25 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.2 | grep 'package installed'
RUN android list sdk --all
RUN yes | sdkmanager --update
RUN apt-get clean
RUN chown -R 1000:1000 $ANDROID_HOME
