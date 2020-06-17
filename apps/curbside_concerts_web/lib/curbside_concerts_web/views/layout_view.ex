defmodule CurbsideConcertsWeb.LayoutView do
  @moduledoc """
  This view contains helpers that can be used to render components that
  appear in multiple places throughout the site.
  """

  use CurbsideConcertsWeb, :view

  alias CurbsideConcertsWeb.Structs.Link

  @doc """
  Given a list of Link structs, renders a <nav> element containing several <a> children.
  This is intended to work with get_nav_links to quickly render a consistent navigation
  across several pages.

  Example Usage:
  ```
  import CurbsideConcertsWeb.LayoutView

  ...

  <%= LayoutView.render_nav_links(LayoutView.get_nav_links("HOME")) %>
  ```
  """
  @spec render_nav_links([Link.t()]) :: {:safe, [...]}
  def render_nav_links(links) do
    ~E"""
    <nav>
    <%= for %Link{current: current, label: label, path: path} <- links do %>
    <%= link label, to: path, class: if current, do: "link current", else: "link" %>
    <% end %>
    </nav>
    """
  end

  def get_nav_links(current_label) do
    nav_links = [
      %Link{label: "HOME", path: Routes.landing_path(CurbsideConcertsWeb.Endpoint, :index)},
      %Link{label: "REQUEST", path: Routes.request_path(CurbsideConcertsWeb.Endpoint, :new)},
      %Link{label: "TIPS", path: Routes.musician_path(CurbsideConcertsWeb.Endpoint, :artists)},
      %Link{label: "PERFORM", path: Routes.perform_path(CurbsideConcertsWeb.Endpoint, :index)},
      %Link{
        label: "VOLUNTEER",
        path: Routes.landing_path(CurbsideConcertsWeb.Endpoint, :volunteer)
      }
    ]

    Enum.map(nav_links, fn %Link{label: label} = link ->
      if label == current_label do
        %Link{link | current: true}
      else
        link
      end
    end)
  end
end
