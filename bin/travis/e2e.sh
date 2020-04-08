#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

mix run apps/curbside_concerts/priv/repo/test_user_seed.exs
npm install --prefix e2e
mix phx.server &
npm test --prefix e2e
kill $(jobs -p) || true

exit 0