FROM node:20-alpine

# Set environment
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies (pakai apk)
RUN apk update && apk upgrade && \
    apk add --no-cache \
    openssh \
    git \
    wget \
    sudo \
    nano \
    curl \
    tmate \
    python3 \
    py3-pip \
    build-base \
    bash \
    shadow \
    && rm -rf /var/cache/apk/*

# Buat startup script
RUN mkdir -p /run/sshd \
    && echo "sleep 5" > /openssh.sh \
    && echo "tmate -F &" >> /openssh.sh \
    && echo "/usr/sbin/sshd -D" >> /openssh.sh \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "root:147" | chpasswd \
    && chmod +x /openssh.sh

# Jalankan script pakai bash
CMD ["bash", "/openssh.sh"]
