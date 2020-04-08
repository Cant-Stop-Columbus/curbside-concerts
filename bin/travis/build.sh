#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

mix compile
(cd apps/curbside_concerts && mix ecto.setup)
(cd apps/curbside_concerts_web && npm install --prefix assets)

if [ $MIX_ENV == "prod" ]; then
  (cd apps/curbside_concerts_web && npm run deploy --prefix assets)
fi