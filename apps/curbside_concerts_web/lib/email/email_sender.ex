defmodule CurbsideConcertsWeb.EmailSender do
  alias CurbsideConcertsWeb.Email
  alias CurbsideConcertsWeb.Mailer

  def send_request_confirmation(request, tracker_url) do
    Email.request_confirmation(request, tracker_url)
    |> Mailer.deliver_now()
  end
end