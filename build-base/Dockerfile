FROM debian:trixie AS build

# Install WINE build dependencies
RUN sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/debian.sources
RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" apt-get build-dep --install-recommends -y wine && \
    # debian does not pull in i686 mingw (needed for building "experimental wow64" support)
    DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc-mingw-w64-i686 && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# Build and install patched WINE (see https://github.com/msys2/MSYS2-packages/issues/682)
COPY patches /tmp/wine-patches
RUN git clone --filter=tree:0 https://gitlab.winehq.org/wine/wine.git /tmp/winesrc && \
    cd /tmp/winesrc && \
    git checkout wine-11.15 && \
    git apply /tmp/wine-patches/*.patch && \
    ./configure --disable-tests --enable-win64 --with-mingw --enable-archs=x86_64,i386 && \
    make -j $(nproc) && \
    env DESTDIR=/wine make -j $(nproc) install && \
    rm -rf /tmp/winesrc /tmp/wine-patches && \
    # Clean things up
    rm -Rf /wine/usr/local/include && \
    find /wine -type f -exec strip --strip-all {} \;
