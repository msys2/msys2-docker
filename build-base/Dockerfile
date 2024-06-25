FROM debian:bookworm AS build

# Install WINE build dependencies
RUN sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/debian.sources
RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt-get build-dep --install-recommends -y wine
# debian does not pull in i686 mingw (needed for building "experimental wow64" support)
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc-mingw-w64-i686

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y git

# Build and install patched WINE (see https://github.com/msys2/MSYS2-packages/issues/682)
RUN git clone https://gitlab.winehq.org/jhol/wine.git /tmp/winesrc
WORKDIR /tmp/winesrc
# https://gitlab.winehq.org/jhol/wine/-/commits/msys2-hacks-17
RUN git checkout aed38b3fea259c23738d60df67d562592d394393
RUN ./configure --disable-tests --enable-win64 --with-mingw --enable-archs=x86_64,i386
RUN make -j $(nproc)
RUN env DESTDIR=/wine make -j $(nproc) install
RUN rm -rf /tmp/winesrc

# Clean things up
RUN find /wine -type f -exec strip --strip-all {} \;
RUN rm -Rf /wine/usr/local/include
