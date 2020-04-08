#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# install dependencies
mix deps.get
(cd apps/curbside_concerts_web && npm install --prefix assets)

# setup database: create, migrate, and seed
(cd apps/curbside_concerts && mix ecto.reset)
