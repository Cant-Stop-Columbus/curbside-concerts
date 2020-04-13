defmodule TestHelper do
  import CurbsideConcerts.Factory
  import  ExUnit.Assertions

  alias CurbsideConcertsWeb.Email
  alias CurbsideConcerts.Repo

  def test_assert_email_fields(contact_preference, contact_preference_display_text) do
    request = 
      insert!(:request, %{contact_preference: contact_preference})
      |> Repo.preload([:genres])
    
    %Bamboo.Email{assigns: assigns} = email = Email.request_confirmation(request)
    assert email.subject == "Request Confirmation"
    assert email.to == request.requester_email
    assert assigns.tracker_url  =~ "tracker"
    assert assigns.request == request
    assert assigns.contact_preference == contact_preference_display_text
  end
end

defmodule CurbsideConcertsWeb.EmailTest do
  use ExUnit.Case
  
  import TestHelper

  alias CurbsideConcerts.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "request_confirmation/1" do
    
    test "creates the email with call_nominee" do
      assert test_assert_email_fields("call_nominee", "Call Nomniee")
    end

    test "creates the email with call_requester" do
      assert test_assert_email_fields("call_requester", "Call me")
    end

    test "creates the email with text_requester" do
      assert test_assert_email_fields("text_requester", "Text me")
    end
  end
end