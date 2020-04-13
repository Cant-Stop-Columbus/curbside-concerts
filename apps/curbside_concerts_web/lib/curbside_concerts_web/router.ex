defmodule CurbsideConcertsWeb.Router do
  use CurbsideConcertsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(CurbsideConcertsWeb.Plugs.SetCurrentUser)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :requires_auth do
    plug CurbsideConcertsWeb.Plugs.AuthenticateUser
  end

  scope "/", CurbsideConcertsWeb do
    pipe_through :browser

    get "/", LandingController, :index
    get "/tips", TipsController, :index
    get "/tracker/:tracker_id", RequestController, :tracker

    get "/session/driver/:driver_id", SessionController, :session_route_driver

    get "/session/artist/:artist_id", SessionController, :session_route_artist

    get "/request", RequestController, :new
    post "/request", RequestController, :create
    put "/cancel_request/:tracker_id", RequestController, :cancel_request

    get "/admin", AdminController, :index

    get("/sign-in", AccountSessionController, :new)
    post("/sign-in", AccountSessionController, :create)
  end

  scope "/", CurbsideConcertsWeb do
    pipe_through [:browser, :requires_auth]

    get "/reports/genres", ReportsController, :genres

    get "/musician_builder/new", MusicianController, :new
    post "/musician_builder/new", MusicianController, :create
    get "/musician_builder", MusicianController, :index

    resources "/session", SessionController, only: [:create, :edit, :index, :new, :update, :show]
    get "/session/archived", SessionController, :index_archived
    put "/session/:id/archive", SessionController, :archive

    resources "/genre", GenreController, only: [:index, :create, :edit, :new, :update, :show]

    live "/session_booker/:session_id", SessionBookerLive, as: :session_booker

    get "/last_minute_gigs", RequestController, :last_minute_gigs
    get "/gigs", RequestController, :index
    get "/gigs/:musician", RequestController, :index

    delete("/sign-out", AccountSessionController, :delete)
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  # Other scopes may use custom stacks.
  # scope "/api", CurbsideConcertsWeb do
  #   pipe_through :api
  # end
end
