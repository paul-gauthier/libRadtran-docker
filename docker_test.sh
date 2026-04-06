#!/usr/bin/env bash
set -euo pipefail

docker run --rm libradtran:2.0.6 make check
