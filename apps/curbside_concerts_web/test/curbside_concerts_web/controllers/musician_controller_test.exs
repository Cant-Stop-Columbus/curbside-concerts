defmodule CurbsideConcertsWeb.MusicianControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: false

  import CurbsideConcerts.Factory

  def auth_user(%{conn: conn}) do
    %User{} = user = insert!(:user)

    conn =
      conn
      |> with_authenticated_user(user)

    %{conn: conn}
  end
end
