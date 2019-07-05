defmodule TimelineWeb.ApiController do
  use TimelineWeb, :controller
  alias Timeline.Portfolio

  def calculate(conn, %{
        "amount" => amount,
        "percentages" => percentages,
        "date" => date,
        "rebalanceFrequency" => rebalance_frequency
      }) do
    date = Date.from_iso8601!(date)

    {:ok, values, _} =
      Portfolio.calculate_timeline(amount, percentages, date, rebalance_frequency)

    conn |> json(values)
  end
end
