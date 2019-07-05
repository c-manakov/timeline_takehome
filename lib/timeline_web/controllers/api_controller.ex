defmodule TimelineWeb.ApiController do
  use TimelineWeb, :controller
  alias Timeline.Portfolio

  def calculate(conn, %{"amount" => amount, "percentages" => percentages, "date" => date}) do
    date = Date.from_iso8601!(date)
    {:ok, values, _} = Portfolio.calculate_portfolio_values(amount, percentages, date)
    conn |> json(values)
  end
end
