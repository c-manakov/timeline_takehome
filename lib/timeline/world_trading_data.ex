defmodule Timeline.WorldTradingData do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.worldtradingdata.com/api/v1"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query,
    [api_token: Application.fetch_env!(:timeline, :trading_api)[:trading_api_key]]

  def get_historical_data(symbol, date_from \\ nil) do
    case get("/history", query: [symbol: symbol, sort: "asc", date_from: date_from]) do
      {:ok, %{body: %{"history" => history}} = response} ->
        response = put_in(response.body["history"], sort_history(history))
        {:ok, response}
      {:ok, %{body: %{"Message" => message}}} ->
        {:err, message, symbol}
      otherwise ->
        otherwise
    end

  end

  defp sort_history(history) do
    history
    |> Enum.map(fn {key, value} -> {Date.from_iso8601!(key), value} end)
    |> Enum.sort(fn {key1, _}, {key2, _} ->
        Date.compare(key1, key2) == :lt
      end)
  end
end
