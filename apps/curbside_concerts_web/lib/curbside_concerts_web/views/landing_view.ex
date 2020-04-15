defmodule CurbsideConcertsWeb.LandingView do
  @moduledoc false

  use CurbsideConcertsWeb, :view

  alias CurbsideConcertsWeb.LayoutView

  def story_image() do
    alt_text =
      "A man plays guitar from the bed of a pickup truck parked in a driveway, while a woman records it on her phone. In the background, other people from the neighborhood stand in their lawns observing the performance.'\""

    ~E"""
    <img src="/images/landing_story.png" alt="<%= alt_text %>" />
    """
  end
end
