defmodule CurbsideConcertsWeb.EmailRequest do
  import Bamboo.Email

  use Bamboo.Phoenix, view: CurbsideConcertsWeb.EmailView

  alias CurbsideConcerts.Requests
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcertsWeb.Mailer

  def send_session_booked(request_id) do
    # IO.puts("********************** sending " <> to_email)
    # Process.sleep(5000)
    # if(to_email =~ "some") do
    #   throw("Error")
    # end
    # test_email(to_email) 
    # |>  CurbsideConcertsWeb.Mailer.deliver_now()
    # IO.puts("********************** sent " <> to_email)
    request = Requests.find_request_with_children(request_id)
    email(request) 
    |>  Mailer.deliver_now()
  end
  
  defp email(%Request{} = request) do
    new_email()
    |> to(request.requester_email)
    |> from({"Curbside Concerts", "testuser@sendaconcert.com"})
    |> subject("Your session has been booked!")
    |> assign(:request, request)
    |> assign(:session, request.session)
    |> assign(:musician, request.session.musician)
    |> put_html_layout({CurbsideConcertsWeb.LayoutView, "email.html"})
    |> render("session_booked.html")
  end
end
