defmodule CurbsideConcertsWeb.EmailRequestTest do
  use ExUnit.Case
  use Bamboo.Test

  import CurbsideConcerts.Factory

  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcerts.Repo
  alias CurbsideConcertsWeb.EmailRequest

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "send_session_booked/1" do
    test "sends the email" do
      %Session{id: session_id} = insert!(:session)
      insert!(:musician, %{ session_id: session_id})
      %Request{id: request_id, requester_email: email_address} = insert!(:request, %{ session_id: session_id})
        |> Repo.preload([{:session, :musician}])
      expected_email = EmailRequest.send_session_booked(request_id)

      assert_delivered_email expected_email
      assert expected_email.to == [{nil, email_address}]
      assert expected_email.from == {"Curbside Concerts", "testuser@sendaconcert.com"}
      assert expected_email.html_body != nil
    end
  end
end
