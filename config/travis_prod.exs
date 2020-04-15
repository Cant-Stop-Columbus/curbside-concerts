# This file replaces config/test.exs before executing CI checks in Travis (see .travis.yml).
# We need to do this to ensure the database and endpoint configurations below,
# which are unique to Travis.
# This file should _not_ be used outside of Travis.

use Mix.Config

config :curbside_concerts, CurbsideConcerts.Repo,
  username: "postgres",
  password: "",
  database: "curbside_concerts_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :curbside_concerts_web, CurbsideConcertsWeb.Endpoint, http: [port: 4000]

config :logger, level: :info
