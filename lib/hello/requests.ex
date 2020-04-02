defmodule Hello.Requests do
  alias Hello.Requests.Request

  def change_request(%Request{} = request) do
    Request.changeset(request, %{})
  end
end
