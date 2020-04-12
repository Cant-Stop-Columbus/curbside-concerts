defmodule CurbsideConcertsWeb.EmailSender do
  alias CurbsideConcertsWeb.Email
  alias CurbsideConcertsWeb.Mailer

  def send_request_confirmation(request) do
    Email.request_confirmation(request)
    |> Mailer.deliver_now()
  end
end