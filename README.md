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

## Authentication

Some routes (such as "/admin") are account-protected. On local, this means you'll need to create a user account in the database.

```
iex -S mix
> Hello.Accounts.create_user(%{username: "admin", password: "password"})
```

Then, you can log in with the credentials you created.

## Deployment

At the moment, this repository is connected directly to [the Heroku Project](https://dashboard.heroku.com/apps/sendaconcert). Pushing to master will automatically kick off a build and deploy.

If your change also requires a database migration, be sure to run that after the build completes:

```sh
heroku run "POOL_SIZE=2 mix ecto.migrate" -a <heroku_app_name>
```

## Deployment Configuration

These are the steps needed to configure this application for a new Heroku project.

1. [Heroku Buildpack for Elixir](https://github.com/HashNuke/heroku-buildpack-elixir): `heroku buildpacks:add hashnuke/elixir -a <heroku_app_name>`
2. [Phoenix Static Buildpack](https://github.com/gjaldon/heroku-buildpack-phoenix-static): `heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static -a <heroku_app_name`
3. Follow the instructions on [the Phoenix Docs](https://hexdocs.pm/phoenix/heroku.html#making-our-project-ready-for-heroku) to set up the app with Postgres on Heroku.

**Note**: If you get zipfile errors when building in Heroku, try setting a different Elixir / Erlang version in `elixir_buildpack.config`. At the time of this writing, we were unable to get Elixir 1.10.* to deploy successfully.