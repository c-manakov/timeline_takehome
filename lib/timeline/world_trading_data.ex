defmodule Timeline.WorldTradingData do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.worldtradingdata.com/api/v1"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query,
    [api_token: Application.fetch_env!(:timeline, :trading_api)[:trading_api_key]]

  def get_historical_data(symbol, date_from \\ nil) do
    get("/history", query: [symbol: symbol, sort: "asc", date_from: date_from])
  end
end
