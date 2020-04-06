#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

mix run priv/repo/seeds.exs
npm install --prefix e2e
mix phx.server &
npm test --prefix e2e
kill $(jobs -p) || true

exit 0