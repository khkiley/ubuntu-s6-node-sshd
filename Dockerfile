FROM node:14.17.0-buster

##
## ROOTFS
##

# root filesystem
COPY rootfs /

# s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz
RUN tar xvfz /tmp/s6-overlay.tar.gz -C /

# Install OpenSSH and set the password for root to "Docker!". 
RUN apt update
RUN apt install netcat -y
RUN apt install openssh-server -y \
     && echo "root:Docker!" | chpasswd 

# Copy the sshd_config file to the /etc/ssh/ directory
COPY sshd_config /etc/ssh/

RUN /etc/init.d/ssh start
RUN /etc/init.d/ssh stop

# Open port 2222 for SSH access
EXPOSE 8506 2222
RUN mkdir /app

COPY server.js /app

RUN chown node:node -R /app


##
## INIT
##

ENTRYPOINT [ "/init" ]
