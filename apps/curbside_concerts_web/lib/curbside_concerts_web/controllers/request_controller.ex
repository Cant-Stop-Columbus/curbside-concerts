defmodule CurbsideConcertsWeb.RequestController do
  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Requests
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcerts.Musicians
  alias CurbsideConcertsWeb.TrackerCypher
  alias CurbsideConcertsWeb.EmailSender
  alias CurbsideConcertsWeb.Helpers.HostPath

  def new(conn, _params) do
    genres = Musicians.all_genres()

    changeset =
      Requests.change_request(%Request{
        genres: []
      })

    render(conn, "new.html", changeset: changeset, genres: genres)
  end

  def create(conn, %{"request" => request_params}) do
    case Requests.create_request(request_params) do
      {:ok, %Request{id: request_id, nominee_name: nominee_name} = request} ->
        tracker_id = TrackerCypher.encode(request_id)
        EmailSender.send_request_confirmation(request, HostPath.tracker_url(tracker_id))
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

  def index(conn, %{"musician" => gigs_id}) do
    musician = Musicians.find_musician_by_gigs_id(gigs_id)
    requests = Requests.get_by_gigs_id(gigs_id)

    conn
    |> assign(:requests, requests)
    |> assign(:musician, musician)
    |> render("musician_gigs.html")
  end

  def index(conn, _) do
    conn
    |> assign(:requests, Requests.all_requests(preloads: [:genres]))
    |> render("index.html")
  end

  def tracker(conn, %{"tracker_id" => tracker_id}) do
    request_id = TrackerCypher.decode(tracker_id)
    request = Requests.find_request(request_id)

    conn
    |> assign(:tracker_id, tracker_id)
    |> assign(:request_id, request_id)
    |> assign(:request, request)
    |> render("tracker.html")
  end
end
