defmodule CurbsideConcertsWeb.EmailView do
  use CurbsideConcertsWeb, :view

  alias CurbsideConcertsWeb.Helpers.RequestAddress
  alias CurbsideConcertsWeb.Helpers.HostPath

  def preference_display_text(contact_preference) do
    case contact_preference do
      "call_nominee" -> "Call Nomniee"
      "text_requester" -> "Text me"
      "call_requester" -> "Call me"
    end
  end

end
