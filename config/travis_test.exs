use Mix.Config

# Configure your database
config :curbside_concerts, CurbsideConcerts.Repo,
  username: "postgres",
  password: "",
  database: "curbside_concerts_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :curbside_concerts, CurbsideConcertsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
