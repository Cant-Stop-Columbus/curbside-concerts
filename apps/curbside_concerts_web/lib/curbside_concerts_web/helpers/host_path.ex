defmodule CurbsideConcertsWeb.Helpers.HostPath do
  alias CurbsideConcertsWeb.Router.Helpers, as: Routes
  alias CurbsideConcertsWeb.TrackerCypher

  def tracker_url(request_id) do
    tracker_id = TrackerCypher.encode(request_id)
    CurbsideConcertsWeb.Endpoint.url <> Routes.request_path(CurbsideConcertsWeb.Endpoint, :tracker, tracker_id)
  end
end 
