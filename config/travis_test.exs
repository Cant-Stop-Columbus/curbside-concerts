# This file replaces config/prod.exs before executing CI checks in Travis (see .travis.yml).
# We need to do this to ensure the database configuration below, which is unique to Travis.
# This file should _not_ be used outside of Travis.

use Mix.Config

config :curbside_concerts, CurbsideConcerts.Repo,
  username: "postgres",
  password: "",
  database: "curbside_concerts_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :curbside_concerts_web, CurbsideConcertsWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
