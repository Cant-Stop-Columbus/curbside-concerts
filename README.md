# Curbside Concerts

This repository contains the source code for Curbside Concerts, a charity project that Test Double is working on for [Can't Stop Columbus](https://cantstopcolumbus.web.app/).

Please see the [project BaseCamp](https://3.basecamp.com/4445163/projects/16536595) or the #cause-cantstopcolumbus channel in Slack for more information.

## Deployment Configuration

This app is currently deployed to Heroku, using the [Heroku Buildpack for Elixir](https://github.com/HashNuke/heroku-buildpack-elixir).

To deploy:

1. Create a Heroku project linked to this GitHub repo
2. Add the buildpack to the existing Heroku project: `heroku buildpacks:set hashnuke/elixir`

**Note**: If you get zipfile errors when building in Heroku, try setting a different Elixir / Erlang version in `elixir_buildpack.config`. At the time of this writing, we were unable to get Elixir 1.10.* to deploy successfully.