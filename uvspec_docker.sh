#!/usr/bin/env bash
set -euo pipefail
host_pwd="$(pwd)"
exec docker run --rm -i \
    -v "${host_pwd}:${host_pwd}" \
    -w /opt/libRadtran-2.0.6 \
    libradtran:2.0.6 uvspec "$@"
