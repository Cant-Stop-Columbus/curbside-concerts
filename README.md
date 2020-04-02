# Curbside Concerts

This repository contains the source code for Curbside Concerts, a charity project that Test Double is working on for [Can't Stop Columbus](https://cantstopcolumbus.web.app/).

Please see the [project BaseCamp](https://3.basecamp.com/4445163/projects/16536595) or the #cause-cantstopcolumbus channel in Slack for more information.

## Getting Started

First time setup:

```sh
# install dependencies
mix deps.get
(cd assets && npm install)

# initialize the database
docker-compose up -d
mix ecto.setup
```

To run the app locally:

```sh
# start the postgres database
docker-compose up -d

# start the elixir application
mix phx.server
```

## Deployment Configuration

This app is currently deployed to Heroku, using the following build packs:
1. [Heroku Buildpack for Elixir](https://github.com/HashNuke/heroku-buildpack-elixir): `heroku buildpacks:add hashnuke/elixir -a <heroku_app_name>`
2. [Phoenix Static Buildpack](https://github.com/gjaldon/heroku-buildpack-phoenix-static): `heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static -a <heroku_app_name`

**Note**: If you get zipfile errors when building in Heroku, try setting a different Elixir / Erlang version in `elixir_buildpack.config`. At the time of this writing, we were unable to get Elixir 1.10.* to deploy successfully.