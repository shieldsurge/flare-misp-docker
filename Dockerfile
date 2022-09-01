FROM ubuntu:jammy

# Install core components
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && apt-get upgrade && apt-get autoremove -y && apt-get clean && \
    apt-get install -y software-properties-common
    
# Install necessary packages
RUN apt-get install -y maven openjdk-8-jdk sudo git supervisor

# Install troubleshooting/development packages
RUN apt-get install -y vim emacs nano curl

WORKDIR /opt/
RUN git clone https://github.com/cisagov/flare-misp-service.git
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
