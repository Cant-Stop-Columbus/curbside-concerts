defmodule CurbsideConcertsWeb.Email do
  import Bamboo.Email
  
  def test_email do
    new_email(
      to: "someone@something.com",
      from: "support@curbsideconcerts.com",
      subject: "Test Email.",
      html_body: "<strong>This is the body!</strong>",
      text_body: "Thanks for doing the thing!"
    )
  end
end