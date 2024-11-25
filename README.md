# MSYS2 Docker Images (Experimental)

This repository provides Docker images including MSYS2.

## Linux & Wine

**WARNING:** Package and database signature checks are currently disabled to
speed up the build process. This Docker image is not recommended for production
use.

Simply run the image to get a shell:

```console
$ docker run -it ghcr.io/msys2/msys2-docker-experimental
D406664E7A3F+root@d406664e7a3f UCRT64 ~
# uname -a
MINGW64_NT-10.0-19043 d406664e7a3f 3.4.10.x86_64 2024-04-08 18:11 UTC x86_64 Msys
```

It defaults to the `UCRT64` environment. Pass `-eMSYSTEM=CLANG64` etc to change the default environment.

Or alternatively use the included `msys2` command which runs bash:

```console
$ docker run -it ghcr.io/msys2/msys2-docker-experimental msys2 -c "uname -a"
MINGW64_NT-10.0-19043 51eee8aa4763 3.4.10.x86_64 2024-04-08 18:11 UTC x86_64 Msys
```

Acknowledgments:

* The Dockerfile is inspired by the following
  [Dockerfile](https://github.com/pojntfx/hydrapp/blob/main/hydrapp/pkg/builders/msi/Dockerfile)
  by [@pojntfx (Felicitas Pojtinger)](https://github.com/pojntfx)
* The [Wine fork](https://gitlab.winehq.org/jhol/wine) including the necessary
  MSYS2/Cygwin specific changes is developed by [@jhol (Joel
  Holdsworth)](https://github.com/jhol)

## Windows

Would they be useful? Let us know.

## License

Everything in this repository is licensed under the
[BSD-3-Clause](https://spdx.org/licenses/BSD-3-Clause.html) License unless
otherwise noted.
