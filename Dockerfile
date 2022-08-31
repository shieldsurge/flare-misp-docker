FROM ubuntu:jammy

# Install core components
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && apt-get upgrade && apt-get autoremove -y && apt-get clean && \
    apt-get install -y software-properties-common
    
RUN apt-get install -y maven openjdk-8-jdk

RUN git clone https://github.com/microsoftgraph/security-api-solutions.git
