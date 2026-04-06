# libRadtran Docker Build

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
- installs the required build tools and libraries
- runs `./configure` with `PYTHON=python3`
- builds the project with `make -j"$(nproc)"`

The container `PATH` is configured to include the libRadtran `bin` directory, and the working directory is set to the extracted source tree.

## Repository files

- `Dockerfile` - defines the Docker image and builds libRadtran
- `docker_build.sh` - builds the `libradtran:2.0.6` image
- `docker_test.sh` - runs `make check` inside the container

## Optional: open a shell in the container

To inspect the built environment manually:

```bash
docker run --rm -it libradtran:2.0.6 bash
```

## Notes

- Building the image requires internet access to download the libRadtran source tarball.
- Tests run inside the container.

