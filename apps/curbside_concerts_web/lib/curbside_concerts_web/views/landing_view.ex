defmodule CurbsideConcertsWeb.LandingView do
  @moduledoc false

  use CurbsideConcertsWeb, :view

  def hero_image() do
    alt_text =
      "A man sitting in the bed of a pickup truck plays guitar for an elderly woman standing in her driveway. A speech bubble over the man says \"That song was for you. People care about you. This is from your daughter: 'Mom, we know it's hard to be alone but we want you to be safe. We hope this song brightens your day. We love you.'\""

    ~E"""
    <img src="/images/for_you.png" alt="<%= alt_text %>" />
    """
  end
end
