FROM node:20-alpine

ENV DEBIAN_FRONTEND=noninteractive

RUN apk update && apk upgrade && \
    apk add --no-cache \
    openssh \
    git \
    wget \
    sudo \
    nano \
    curl \
    python3 \
    py3-pip \
    build-base \
    bash \
    shadow \
    && rm -rf /var/cache/apk/*

# Setup SSH optional
RUN mkdir -p /run/sshd \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "root:147" | chpasswd

# Default langsung ke bash interactive
CMD ["/bin/bash"]
