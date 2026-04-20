FROM ghcr.io/msys2/msys2-docker-build-base AS build

# Install dependencies and download Cygwin setup
RUN apt update && apt install -y --no-install-recommends curl ca-certificates

# Download Cygwin setup executable
RUN mkdir -p /tmp/cygwin
RUN curl --fail -L 'https://www.cygwin.com/setup-x86_64.exe' -o /tmp/cygwin/setup-x86_64.exe

FROM debian:trixie

# Install runtime deps
RUN apt update \
    && apt install -y --no-install-recommends xvfb wine64 xauth ca-certificates \
    && apt remove -y wine64 libwine \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /wine /
RUN ldconfig

# Avoid "tzset" startup warning + wineboot crashing
ENV TZ=UTC

# Initialize Wine
RUN WINEDEBUG=-all wineboot --init && wineserver --wait

# Copy Cygwin setup into Wine's filesystem
COPY --from=build /tmp/cygwin/setup-x86_64.exe /tmp/setup-x86_64.exe

# Install Cygwin via Wine
RUN WINEDEBUG=-all xvfb-run -a wine /tmp/setup-x86_64.exe \
    --quiet-mode \
    --no-shortcuts \
    --no-startmenu \
    --no-desktop \
    --root 'C:\cygwin64' \
    --site 'https://mirrors.kernel.org/sourceware/cygwin/' \
    --local-package-dir 'C:\cygwin64\packages' \
    && wineserver --wait \
    && rm -Rf  /root/.wine/drive_c/cygwin64/packages \
    && mv /tmp/setup-x86_64.exe /root/.wine/drive_c/cygwin64/bin/setup.exe

COPY ./cygwin /usr/bin/cygwin
RUN chmod +x /usr/bin/cygwin

WORKDIR /root/.wine/drive_c/cygwin64/home/root
CMD ["cygwin"]
