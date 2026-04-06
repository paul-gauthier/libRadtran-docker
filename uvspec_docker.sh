#!/usr/bin/env bash
set -euo pipefail
exec docker run --rm -i \
    -v "$(pwd):$(pwd)" \
    -w "$(pwd)" \
    libradtran:2.0.6 uvspec "$@"
