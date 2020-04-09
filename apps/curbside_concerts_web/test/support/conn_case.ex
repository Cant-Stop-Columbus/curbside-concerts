defmodule CurbsideConcertsWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use CurbsideConcertsWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias CurbsideConcerts.Accounts.User

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias CurbsideConcertsWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint CurbsideConcertsWeb.Endpoint

      import CurbsideConcertsWeb.ConnCase, only: [with_authenticated_user: 2]
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CurbsideConcerts.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(CurbsideConcerts.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def with_authenticated_user(%Plug.Conn{} = conn, %User{} = user) do
    conn
    |> Plug.Test.init_test_session(current_user_id: user.id)
  end
end
