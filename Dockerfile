FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ARG LIBRADTRAN_VERSION=2.0.6

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    wget \
    ca-certificates \
    perl \
    flex \
    bison \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget -O libRadtran.tar.gz \
      https://www.libradtran.org/download/libRadtran-${LIBRADTRAN_VERSION}.tar.gz \
 && tar -xzf libRadtran.tar.gz \
 && rm libRadtran.tar.gz \
 && cd libRadtran-${LIBRADTRAN_VERSION} \
 && ./configure \
 && make -j"$(nproc)"

ENV PATH="/opt/libRadtran-${LIBRADTRAN_VERSION}/bin:${PATH}"
WORKDIR /opt/libRadtran-${LIBRADTRAN_VERSION}
