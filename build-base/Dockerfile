FROM debian:bookworm AS build

# Install WINE build dependencies
RUN sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/debian.sources
RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" apt-get build-dep --install-recommends -y wine && \
    # debian does not pull in i686 mingw (needed for building "experimental wow64" support)
    DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc-mingw-w64-i686 && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# Build and install patched WINE (see https://github.com/msys2/MSYS2-packages/issues/682)
RUN git clone --filter=tree:0 https://gitlab.winehq.org/jhol/wine.git /tmp/winesrc && \
    cd /tmp/winesrc && \
    # https://gitlab.winehq.org/jhol/wine/-/commits/msys2-hacks-21
    git checkout 8ea3a1155e80d004aeeb5651f51e07d96a37a78c && \
    ./configure --disable-tests --enable-win64 --with-mingw --enable-archs=x86_64,i386 && \
    make -j $(nproc) && \
    env DESTDIR=/wine make -j $(nproc) install && \
    rm -rf /tmp/winesrc && \
    # Clean things up
    find /wine -type f -exec strip --strip-all {} \; && \
    rm -Rf /wine/usr/local/include
