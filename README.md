# Curbside Concerts

[![Build Status](https://travis-ci.org/testdouble/curbside-concerts.svg?branch=master)](https://travis-ci.org/testdouble/curbside-concerts)

This repository contains the source code for Curbside Concerts / Send a Concert, a charity project that Test Double is working on with [Can't Stop Columbus](https://cantstopcolumbus.web.app/).

## Dependencies:

1. Elixir

We recommend using [exenv](https://github.com/exenv/exenv), to automatically use the local version defined in `.exenv-version`. Alternatively, follow the instructions in the [Elixir Install Page](https://elixir-lang.org/install.html).

2. Erlang

Erlang can be installed through homebrew:

```
brew install erlang
```

3. [Phoenix](https://hexdocs.pm/phoenix/installation.html)

4. [Optional][docker and docker-compose](https://docs.docker.com/get-docker/), for running Postgres (recommended). Alternatively, you can install and run Postgres locally.

## Getting Started

First time setup:

```sh
# start up the database, if using docker
docker-compose up -d

# install dependencies and initialize the database
bin/setup.sh
```

To run the app locally:

```sh
# start the postgres database
docker-compose up -d

# start the elixir application
mix phx.server
```

### Running Tests

To run unit tests:

```sh
mix test

# or, use TDD
mix test.watch
```

See the e2e directory README for instruction on running the end-to-end tests using Cypress.

### Authentication

Some routes require authentication. On local, this means you'll need to create a user account in the database.

```
iex -S mix
> CurbsideConcerts.Accounts.create_user(%{username: "admin", password: "password"})
```

Then, you can log in with the credentials you created.

### Using Latest Prod Data to Seed Development Environment

It's possible to develop against a production-like environment locally by copying the database contents from Heroku into your development instance of Postgres.

See the [heroku documentation](https://devcenter.heroku.com/articles/heroku-postgres-import-export) for more information on importing/exporting Postgres databases.

```sh
# Run the local database
docker-compose up -d

# Ensure that production has the latest migrations (it should already)
heroku run "POOL_SIZE=2 mix ecto.migrate" -a <heroku_app_name>

# Generate a backup of the heroku production data
heroku pg:backups:capture -a sendaconcert

# Download the dump file locally, defaults the file name to latest.dump
heroku pg:backups:download -a sendaconcert

# Replace your local db with the downloaded dump.
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d curbside_converts_dev latest.dump
```

## Deployment

At the moment, this repository is connected directly to [the Heroku Project](https://dashboard.heroku.com/apps/sendaconcert). Pushing to master will automatically kick off a build and deploy.

If your change also requires a database migration, be sure to run that after the build completes:

```sh
heroku run "POOL_SIZE=2 mix ecto.migrate" -a <heroku_app_name>
```

To run Elixir code on the deployed instance, you can also access `iex`:

```sh
heroku run "POOL_SIZE=2 iex -S mix" -a <heroku_app_name>
```

_Note_: The `POOL_SIZE` argument here assumes you folowed the Phoenix / Heroku docs linked below, which sets a specific pool size for the app itself.

## Deployment Configuration

These are the steps needed to configure this application for a new Heroku project.

1. [Heroku Buildpack for Elixir](https://github.com/HashNuke/heroku-buildpack-elixir): `heroku buildpacks:add hashnuke/elixir -a <heroku_app_name>`
2. [Phoenix Static Buildpack](https://github.com/gjaldon/heroku-buildpack-phoenix-static): `heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static -a <heroku_app_name`
3. Follow the instructions on [the Phoenix Docs](https://hexdocs.pm/phoenix/heroku.html#making-our-project-ready-for-heroku) to set up the app with Postgres on Heroku.

**Note**: If you get zipfile errors when building in Heroku, try setting a different Elixir / Erlang version in `elixir_buildpack.config`. At the time of this writing, we were unable to get Elixir 1.10.\* to deploy successfully.
