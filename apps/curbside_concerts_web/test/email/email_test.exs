defmodule CurbsideConcertsWeb.EmailTest do
  use ExUnit.Case

  alias CurbsideConcertsWeb.Email

  test "test email" do
    email = Email.test_email

    assert email.to == "someone@something.com"
    assert email.from == "support@curbsideconcerts.com"
    assert email.subject == "Test Email."
    assert email.html_body =~ "<strong>This is the body!</strong>"
    assert email.text_body =~ "Thanks for doing the thing!"
  end
end