FROM ghcr.io/msys2/msys2-docker-build-base AS build

# Install MSYS2
RUN apt update && apt install -y zstd curl
RUN mkdir -p /tmp/msys64
RUN curl --fail -L 'https://github.com/msys2/msys2-installer/releases/download/nightly-x86_64/msys2-base-x86_64-latest.tar.zst' | tar -x --zstd -C /tmp/ --no-same-owner

FROM debian:bookworm

# Copy over wine and install the runtime deps
RUN apt update \
    && apt install -y --no-install-recommends xvfb wine64 xauth \
    && apt remove -y wine64 libwine \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /wine /
RUN ldconfig

# XXX: otherwise things hang
RUN winecfg

# Copy over MSYS2
COPY --from=build /tmp/msys64 /root/.wine/drive_c/msys64

# XXX: Signature validation is too slow, so disable it for now
# To keep the impact of this change lower, we only allow the main mirror
RUN sed -i /root/.wine/drive_c/msys64/etc/pacman.conf -e 's/SigLevel    = Required/SigLevel = Never/g'
RUN echo 'Server = https://repo.msys2.org/msys/$arch/' > /root/.wine/drive_c/msys64/etc/pacman.d/mirrorlist.msys
RUN echo 'Server = https://repo.msys2.org/mingw/$repo/' > /root/.wine/drive_c/msys64/etc/pacman.d/mirrorlist.mingw

# Not strictly necessary, let's skip it for now
RUN sed -i 's/--refresh-keys/--version/g' '/root/.wine/drive_c/msys64/etc/post-install/07-pacman-key.post'

# Disable space checks to speed up package installation
RUN sed -i /root/.wine/drive_c/msys64/etc/pacman.conf -e 's/^CheckSpace/#CheckSpace/g'

COPY ./msys2 /usr/bin/msys2
RUN chmod +x /usr/bin/msys2

# Run for the first time
RUN msys2 -c " "

WORKDIR /root/.wine/drive_c/msys64/home/root
CMD ["msys2"]
