FROM ubuntu:22.04 AS fetch

ENV DEBIAN_FRONTEND=noninteractive
ARG LIBRADTRAN_VERSION=2.0.6

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget -O libRadtran.tar.gz \
      https://www.libradtran.org/download/libRadtran-${LIBRADTRAN_VERSION}.tar.gz

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ARG LIBRADTRAN_VERSION=2.0.6

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    ca-certificates \
    perl \
    python3 \
    python-is-python3 \
    flex \
    bison \
    libnetcdf-dev \
    libgsl-dev \
    gawk \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

COPY --from=fetch /opt/libRadtran.tar.gz /opt/libRadtran.tar.gz

RUN tar -xzf libRadtran.tar.gz \
 && rm libRadtran.tar.gz \
 && cd libRadtran-${LIBRADTRAN_VERSION} \
 && PYTHON=python3 ./configure \
 && mkdir -p /opt/local \
 && ln -s /usr/include /opt/local/include \
 && make -j"$(nproc)"

ENV PATH="/opt/libRadtran-${LIBRADTRAN_VERSION}/bin:${PATH}"
WORKDIR /opt/libRadtran-${LIBRADTRAN_VERSION}
