defmodule Hello.Requests do
  alias Hello.Repo
  alias Hello.Requests.Request

  def change_request(%Request{} = request) do
    Request.changeset(request, %{})
  end

  def create_request(attrs \\ %{}) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
  end

  def all do
    Repo.all(Request)
  end
end
