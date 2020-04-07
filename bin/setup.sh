#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# install dependencies
mix deps.get
npm install --prefix assets

# setup database: create, migrate, and seed
mix ecto.reset
