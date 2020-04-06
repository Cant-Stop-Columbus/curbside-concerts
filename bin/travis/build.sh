#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

mix compile
mix do ecto.create, ecto.migrate
npm install --prefix assets

if [ $MIX_ENV == "prod" ]; then
  npm run deploy --prefix assets
fi