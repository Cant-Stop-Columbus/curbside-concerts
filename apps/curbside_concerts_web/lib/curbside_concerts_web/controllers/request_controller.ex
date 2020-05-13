defmodule CurbsideConcertsWeb.RequestController do
  @moduledoc """
  A controller for the request CRUD. This covers both creating a request on the
  requester side, and managing requests on the admin side.
  """

  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Requests
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcerts.Musicians
  alias CurbsideConcertsWeb.RequestView
  alias CurbsideConcertsWeb.TrackerCypher

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    genres = Musicians.all_active_genres()

    changeset =
      Requests.change_request(%Request{
        genres: []
      })

    render(conn, "new.html", changeset: changeset, genres: genres)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"request" => request_params}) do
    case Requests.create_request(request_params) do
      {:ok, %Request{id: request_id, nominee_name: nominee_name}} ->
        tracker_id = TrackerCypher.encode(request_id)

        conn
        |> put_flash(
          :info,
          "Thank you for submitting a concert request for #{nominee_name}! Please bookmark this page to track its progress."
        )
        |> redirect(to: Routes.request_path(conn, :tracker, tracker_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        data = Requests.load_genres(changeset.data)
        changeset = %{changeset | data: data}

        conn
        |> put_flash(
          :error,
          "Oops! Looks like a field is missing - please check below and try again"
        )
        |> render("new.html", changeset: changeset, genres: Musicians.all_genres())
    end
  end

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, %{"musician" => gigs_id}) do
    musician = Musicians.find_musician_by_gigs_id(gigs_id)
    requests = Requests.get_by_gigs_id(gigs_id)

    conn
    |> assign(:requests, requests)
    |> assign(:musician, musician)
    |> render("musician_gigs.html")
  end

  def index(conn, %{"state" => state} = params) do
    conn
    |> assign(:state, state)
    |> assign(:request_type, RequestView.display_state(state))
    |> assign(:requests, Requests.all_active_requests_by_state(state))
    |> assign(:route, Routes.request_path(conn, :index, params))
    |> render("index.html")
  end

  def index(conn, _) do
    conn
    |> assign(:requests, Requests.all_active_requests())
    |> assign(:route, Routes.request_path(conn, :index))
    |> render("index.html")
  end

  @spec last_minute_gigs(Plug.Conn.t(), any) :: Plug.Conn.t()
  def last_minute_gigs(conn, _) do
    conn
    |> assign(:requests, Requests.all_last_minute_requests())
    |> assign(:request_type, "unbooked")
    |> assign(:route, Routes.request_path(conn, :last_minute_gigs))
    |> render("index.html")
  end

  def archived(conn, _) do
    conn
    |> assign(:requests, Requests.all_archived_requests())
    |> assign(:request_type, "archived")
    |> assign(:route, Routes.request_path(conn, :archived))
    |> render("index.html")
  end

  @spec tracker(Plug.Conn.t(), map) :: Plug.Conn.t()
  def tracker(conn, %{"tracker_id" => tracker_id}) do
    request_id = TrackerCypher.decode(tracker_id)
    request = Requests.find_request(request_id)

    conn
    |> assign(:tracker_id, tracker_id)
    |> assign(:request_id, request_id)
    |> assign(:request, request)
    |> render("tracker.html")
  end

  @spec cancel_request(Plug.Conn.t(), map) :: Plug.Conn.t()
  def cancel_request(conn, %{"tracker_id" => tracker_id}) do
    request_id = TrackerCypher.decode(tracker_id)
    request = Requests.find_request(request_id)

    if request != nil do
      Requests.cancel_request(request)

      conn
      |> put_flash(:info, "The concert request for #{request.nominee_name} has been cancelled.")
      |> redirect(to: Routes.request_path(conn, :new))
    else
      conn
      |> put_flash(:error, "The concert request was not found.")
      |> redirect(to: Routes.request_path(conn, :new))
    end
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    request = Requests.get_request(id, preloads: [:session, :genres])
    render(conn, "show.html", request: request)
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    genres = Musicians.all_active_genres()
    request = Requests.get_request(id, preloads: [:session, :genres])
    changeset = Requests.change_request(request)
    render(conn, "edit.html", request: request, genres: genres, changeset: changeset)
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "request" => request_params}) do
    request = Requests.get_request(id)

    case Requests.update_request(request, request_params) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request updated successfully.")
        |> redirect(to: Routes.request_path(conn, :show, request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", request: request, changeset: changeset)
    end
  end

  @spec archive(Plug.Conn.t(), map) :: Plug.Conn.t()
  def archive(conn, %{"id" => id, "redirect" => redirect}) do
    request = Requests.get_request(id)
    {:ok, _request} = Requests.archive_request(request)

    conn
    |> put_flash(:info, "Request archived successfully.")
    |> redirect(to: redirect)
  end

  @spec unarchive(Plug.Conn.t(), map) :: Plug.Conn.t()
  def unarchive(conn, %{"id" => id, "redirect" => redirect}) do
    request = Requests.get_request(id)
    {:ok, _request} = Requests.unarchive_request(request)

    conn
    |> put_flash(:info, "Request unarchived successfully.")
    |> redirect(to: redirect)
  end

  @doc """
  This route can be used to change the status of a request.

  Path: "/request/:id/state/:state?redirect=:redirect_url"

  Parameters:
  - id: the id of a request
  - state: the string corresponding to a valid request state
  - redirect: the route that should be redirected to after updating the request

  Sample Usage:

  ```
  Routes.request_path(
  	CurbsideConcertsWeb.Endpoint,
  	:state,
  	request,
  	"pending",
  	%{redirect: Routes.request_path(CurbsideConcertsWeb.Endpoint, :index)}
  )
  ```
  """
  @spec state(Plug.Conn.t(), map) :: Plug.Conn.t()
  def state(conn, %{"id" => id, "state" => state, "redirect" => redirect}) do
    request = Requests.get_request(id)

    case state do
      "offmission" -> Requests.off_mission_request(request)
      "pending" -> Requests.back_to_pending_request(request)
      _ -> nil
    end

    conn
    |> put_flash(:info, "Request state updated successfully.")
    |> redirect(to: redirect)
  end

  @spec disclaimer(Plug.Conn.t(), any) :: Plug.Conn.t()
  def disclaimer(conn, _params) do
    render(conn, "disclaimer.html")
  end
end
