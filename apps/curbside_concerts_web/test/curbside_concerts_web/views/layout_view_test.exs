defmodule CurbsideConcertsWeb.LayoutViewTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  alias CurbsideConcertsWeb.LayoutView
  alias CurbsideConcertsWeb.Structs.Link

  # When testing helpers, you may want to import Phoenix.HTML and
  # use functions such as safe_to_string() to convert the helper
  # result into an HTML string.
  import Phoenix.HTML

  describe "render_nav_links/1" do
    test "given a list of links, renders them" do
      nav_links = [
        %Link{label: "HOME", path: Routes.landing_path(CurbsideConcertsWeb.Endpoint, :index)},
        %Link{
          label: "REQUEST",
          path: Routes.request_path(CurbsideConcertsWeb.Endpoint, :new),
          current: true
        },
        %Link{label: "TIPS", path: Routes.tips_path(CurbsideConcertsWeb.Endpoint, :index)},
        %Link{label: "PERFORM", path: Routes.perform_path(CurbsideConcertsWeb.Endpoint, :index)}
      ]

      html =
        nav_links
        |> LayoutView.render_nav_links()
        |> safe_to_string()
        |> Floki.parse_document!()

      assert get_map(nav_links, :path) ==
               html |> Floki.find("a") |> Floki.attribute("href")

      assert get_map_string(nav_links, :label) == html |> Floki.find("a") |> Floki.text()
      assert ["link current"] == html |> Floki.find("a") |> Enum.at(1) |> Floki.attribute("class")
    end
  end

  defp get_map(enum, property) do
    enum
    |> Enum.map(fn x -> x[property] end)
  end

  defp get_map_string(enum, property) do
    enum
    |> get_map(property)
    |> Enum.join()
  end
end
