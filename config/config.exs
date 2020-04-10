# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :curbside_concerts,
  ecto_repos: [CurbsideConcerts.Repo]

config :curbside_concerts_web,
  ecto_repos: [CurbsideConcerts.Repo],
  generators: [context_app: :curbside_concerts]

# Configures the endpoint
config :curbside_concerts_web, CurbsideConcertsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ohz+ngvE8GFpcL+uXhf86wrXuUXRbLz+++c4s08Vmvfve0YDGf4gbqvbaxbgj9j6",
  render_errors: [view: CurbsideConcertsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CurbsideConcerts.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "l7bokeeO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Makes the default TZ database the tzdata one that is loaded in deps
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :curbside_concerts_web, CurbsideConcertsWeb.Mailer,
  adapter: Bamboo.MandrillAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
