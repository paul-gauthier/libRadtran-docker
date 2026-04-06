# libRadtran Docker Build

[libRadtran](https://www.libradtran.org/) (library for radiative transfer) is a collection of C and Fortran functions and programs for calculation of solar and thermal radiation in the Earth's atmosphere. It is freely available under the GNU General Public License.

This repository builds **libRadtran 2.0.6** inside a Docker container and provides a simple, reproducible way to run the upstream test suite on **Ubuntu 22.04**.

## Requirements

- Docker

## Build the image

Run:

```bash
./docker_build.sh
```

This builds a Docker image tagged:

```bash
libradtran:2.0.6
```

## Run tests

Run:

```bash
./docker_test.sh
```

This starts a container from the built image and runs:

```bash
make check
```

## Image details

The Docker image:

- starts from Ubuntu 22.04
- downloads the official libRadtran 2.0.6 source tarball
- downloads and installs the REPTRAN data package, including the data for the REPTRAN absorption parameterization
- installs the required build tools and libraries
- runs `./configure` with `PYTHON=python3`
- builds the project with `make -j"$(nproc)"`

The container `PATH` is configured to include the libRadtran `bin` directory, and the working directory is set to the extracted source tree.

## Repository files

- `Dockerfile` - defines the Docker image and builds libRadtran
- `docker_build.sh` - builds the `libradtran:2.0.6` image
- `docker_test.sh` - runs `make check` inside the container
- `uvspec_docker.sh` - runs `uvspec` inside the container with the current working directory mounted

## Optional: open a shell in the container

To inspect the built environment manually:

```bash
docker run --rm -it libradtran:2.0.6 bash
```

## Running uvspec_docker.sh

Once the image is built you can use `uvspec_docker.sh` as a drop-in replacement
for a native `uvspec` binary. It forwards stdin/stdout and mounts only the
current working directory into the container at the same absolute path, so
files that `uvspec` reads or writes should live in that directory tree.

You should use `/opt/libRadtran-2.0.6/data` as the data path in the
input you provide to uvspec.
That is the libRadtran data path inside the container, and it includes
the installed data for the REPTRAN absorption parameterization.

`uvspec_docker.sh` mounts only `$(pwd)`. Run it from the directory
containing any input, output, or temporary files that `uvspec` needs to
access. Relative paths are resolved from that mounted working directory, and
host paths outside it are not visible inside the container unless you add
extra Docker mounts.

## Notes

- Building the image requires internet access to download the libRadtran source tarball.
- Tests run inside the container.
- This image already includes the REPTRAN absorption parameterization data. See the [libRadtran download page](https://www.libradtran.org/doku.php?id=download) for additional optional data packages, such as cloud and aerosol optical properties.

