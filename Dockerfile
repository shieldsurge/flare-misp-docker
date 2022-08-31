FROM ubuntu:jammy

# Install core components
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && apt-get upgrade && apt-get autoremove -y && apt-get clean && \
    apt-get install -y software-properties-common
    
RUN apt-get install -y vim emacs nano curl

RUN apt-get install -y maven openjdk-8-jdk git

WORKDIR /opt/
RUN git clone https://github.com/microsoftgraph/security-api-solutions.git
WORKDIR /opt/flare-misp-service/misp-trans-client-rest-service/
RUN ./packageDeployment.sh
RUN cp deploy/FLAREmispService.tar /opt/mtc/
WORKDIR /opt/mtc/
RUN tar -xvf FLAREmispService.tar

RUN ( \
    echo '[supervisord]'; \
    echo 'nodaemon = true'; \
    echo ''; \
) >> /etc/supervisor/conf.d/supervisord.conf

ADD run.sh /run.sh
RUN chmod 0755 /run.sh
ENTRYPOINT ["/run.sh"]
