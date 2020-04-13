defmodule CurbsideConcertsWeb.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: CurbsideConcertsWeb.EmailView

  alias CurbsideConcertsWeb.Helpers.HostPath
  alias CurbsideConcertsWeb.TrackerCypher

  
  def request_confirmation(request) do
    base_email()
    |> to(request.requester_email)
    |> subject("Request Confirmation")
    |> assign(:request, request)
    |> assign(:tracker_url, HostPath.tracker_url(TrackerCypher.encode(request.id)))
    |> assign(:contact_preference, preference_display_text(request.contact_preference))
    |> render("request_confirmation.html")
  end

  defp base_email do
    new_email()
    |> from("neilnagarsheth@gmail.com")
    |> put_header("Reply-To", "neilnagarsheth@gmail.com")
    |> put_html_layout({CurbsideConcertsWeb.LayoutView, "email.html"})
  end

  defp preference_display_text(contact_preference) do
    case contact_preference do
      "call_nominee" -> "Call Nomniee"
      "text_requester" -> "Text me"
      "call_requester" -> "Call me"
    end
  end
end

