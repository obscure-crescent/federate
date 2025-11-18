FROM fedora:40

# Install required tools
RUN dnf install -y \
        git \
        wget \
        curl \
        tar \
        ca-certificates \
        gzip \
        bash \
        findutils \
        which \
        hostname \
        podman \
        podman-docker \
        fuse-overlayfs \
        slirp4netns \
        icu-libs \
    && dnf clean all

# Install .NET 9 AspNetCore runtime globally
RUN mkdir -p /usr/share/dotnet && \
    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- \
        --install-dir /usr/share/dotnet \
        --runtime aspnetcore \
        --channel 9.0 && \
    ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet

RUN mkdir -p /etc/containers && \
    printf '%s\n' \
'[storage]' \
'driver = "vfs"' \
'runroot = "/run/containers/storage"' \
'graphroot = "/var/lib/containers/storage"' \
'[''storage.options'']' \
'mount_program = ""' \
    > /etc/containers/storage.conf

RUN ln -sf /usr/bin/podman /usr/local/bin/docker

# Create /opt inside image (host will mount over this)
RUN mkdir -p /opt
RUN mkdir -p /opt/ufw-block && \
    printf '%s\n' \
    '#!/bin/sh' \
    'echo "[INSTALLER BLOCKED] ufw was called in this container. Exiting." >&2' \
    'exit 1' \
    > /usr/local/bin/ufw && \
    chmod +x /usr/local/bin/ufw

WORKDIR /opt

CMD [ "/bin/bash"]