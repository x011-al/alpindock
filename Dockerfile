# Dockerfile (perbaikan untuk Alpine)
FROM node:20-alpine

# environment (opsional)
ENV TZ=UTC

# Install paket utama (dari repo normal) lalu install tmate dari edge/testing
RUN set -eux; \
    apk update; \
    apk upgrade --no-cache; \
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
        shadow; \
    \
    # tmate umumnya di edge/testing -> install langsung dari repo testing
    apk add --no-cache --repository="http://dl-cdn.alpinelinux.org/alpine/edge/testing" tmate; \
    \
    # ensure python symlink and pip usable
    ln -sf /usr/bin/python3 /usr/bin/python || true; \
    pip3 --version || true

# Create startup script (shell sh - portable)
RUN mkdir -p /run/sshd; \
    cat > /openssh.sh <<'EOF'\n#!/bin/sh\nsleep 5\ntmate -F &\n/usr/sbin/sshd -D\nEOF
RUN chmod +x /openssh.sh

# Enable root login via password (hati-hati: security risk)
RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config || true; \
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config || true; \
    echo "root:147" | chpasswd || true

EXPOSE 22

# Jalankan script pakai sh (bash juga ada, tapi sh lebih universal)
CMD ["/bin/sh", "/openssh.sh"]
