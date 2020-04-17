defmodule CurbsideConcertsWeb.Helpers.TimeUtil do
  def days_ago(%{inserted_at: %NaiveDateTime{} = datetime}) do
    past = NaiveDateTime.to_date(datetime)
    now = DateTime.utc_now() |> DateTime.to_date()
    Date.diff(now, past)
  end

  def days_ago(_), do: 0
end
