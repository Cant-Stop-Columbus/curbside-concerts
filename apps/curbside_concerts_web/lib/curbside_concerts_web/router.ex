defmodule CurbsideConcertsWeb.Router do
  use CurbsideConcertsWeb, :router

  alias CurbsideConcertsWeb.Plugs.AuthenticateUser
  alias CurbsideConcertsWeb.Plugs.SetCurrentUser

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(SetCurrentUser)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :requires_auth do
    plug AuthenticateUser
  end

  # This scope contains unauthenticated routes.
  scope "/", CurbsideConcertsWeb do
    pipe_through :browser

    # static home pages
    get "/", LandingController, :index
    get "/tips", MusicianController, :artists
    get "/perform", PerformController, :index

    # status pages
    get "/tracker/:tracker_id", RequestController, :tracker
    live "/session/driver/:driver_id", DriverLive, as: :session_route_driver
    get "/session/artist/:artist_id", SessionController, :session_route_artist

    # request management
    get "/request", RequestController, :new
    post "/request", RequestController, :create
    put "/cancel_request/:tracker_id", RequestController, :cancel_request
    get "/request/disclaimer", RequestController, :disclaimer
    # admin landing page
    get "/admin", AdminController, :index

    # authentication
    get("/sign-in", AccountSessionController, :new)
    post("/sign-in", AccountSessionController, :create)
  end

  # This scope contains authenticated routes.
  scope "/", CurbsideConcertsWeb do
    pipe_through [:browser, :requires_auth]

    # reports
    get "/reports/genres", ReportsController, :genres

    # session booker
    live "/session_booker/:session_id", SessionBookerLive, as: :session_booker

    # gig view
    get "/last_minute_gigs", RequestController, :last_minute_gigs
    get "/archived_requests", RequestController, :archived
    get "/gigs", RequestController, :index
    get "/gigs/:musician", RequestController, :index

    # request management
    get "/request/:id", RequestController, :show
    get "/request/:id/edit", RequestController, :edit
    put "/request/:id/update", RequestController, :update
    put "/request/:id/archive", RequestController, :archive
    put "/request/:id/unarchive", RequestController, :unarchive
    put "/request/:id/state/:state", RequestController, :state

    # musician management
    resources "/musician", MusicianController, only: [:create, :edit, :index, :new, :update, :show]
    
    # session management
    resources "/session", SessionController, only: [:create, :edit, :index, :new, :update, :show]
    get "/session/archived", SessionController, :index_archived
    put "/session/:id/archive", SessionController, :archive
    put "/session/:id/unarchive", SessionController, :unarchive

    # genre management
    resources "/genre", GenreController, only: [:index, :create, :edit, :new, :update, :show]
    put "/genre/:id/archive", GenreController, :archive
    put "/genre/:id/unarchive", GenreController, :unarchive

    # authentication
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
