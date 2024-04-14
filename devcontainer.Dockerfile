FROM ghcr.io/msys2/msys2-docker-experimental

RUN apt update \
    && apt install -y git \
    && rm -rf /var/lib/apt/lists/*

RUN msys2 -c "pacman -S --noconfirm --needed git base-devel"

# Link in the by codespaces injected git config,
# to make the git work in MSYS2 too
RUN ln -s /etc/gitconfig ~/.wine/drive_c/msys64/etc/gitconfig
RUN ln -s /.codespaces ~/.wine/drive_c/msys64/.codespaces
