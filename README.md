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
- downloads and installs the REPTRAN data package
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

## Running the transmission script via Docker

Once the image is built you can use `uvspec_docker.sh` as a drop-in replacement
for a native `uvspec` binary. It forwards stdin/stdout and mounts only the
current working directory into the container at the same absolute path, so
files that `uvspec` reads or writes should live in that directory tree.

```bash
chmod +x uvspec_docker.sh

# Option A: environment variables
export UVSPEC=./uvspec_docker.sh
export LIBRADTRAN_DATA_PATH=/opt/libRadtran-2.0.6/data
python3 run_libradtran_transmission.py

# Option B: CLI flags
python3 run_libradtran_transmission.py \
    --uvspec ./uvspec_docker.sh \
    --data-path /opt/libRadtran-2.0.6/data
```

> **Note:** `LIBRADTRAN_DATA_PATH` (or `--data-path`) is set to a path
> *inside the container*. The Python script only embeds it as text in the
> uvspec input; `uvspec` itself resolves it against the container filesystem
> where the data was installed at build time.
>
> **Note:** `uvspec_docker.sh` mounts only `$(pwd)`. Run it from the directory
> containing any input, output, or temporary files that `uvspec` needs to
> access. Relative paths are resolved from that mounted working directory, and
> host paths outside it are not visible inside the container unless you add
> extra Docker mounts.

## Notes

- Building the image requires internet access to download the libRadtran source tarball.
- Tests run inside the container.
- See the [libRadtran download page](https://www.libradtran.org/doku.php?id=download) for additional optional data packages (e.g. REPTRAN absorption parameterization, cloud and aerosol optical properties).

