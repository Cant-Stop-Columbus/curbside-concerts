defmodule CurbsideConcerts.Repo do
  use Ecto.Repo,
    otp_app: :curbside_concerts,
    adapter: Ecto.Adapters.Postgres
end
