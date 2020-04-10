defmodule CurbsideConcertsWeb.Helpers.HostPath do
  alias CurbsideConcertsWeb.Router.Helpers, as: Routes
  
  def tracker_url(tracker_id) do
    CurbsideConcertsWeb.Endpoint.url <> Routes.request_path(CurbsideConcertsWeb.Endpoint, :tracker, tracker_id)
  end
end