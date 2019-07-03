defmodule Timeline.Portfolio do
  alias Timeline.WorldTradingData

  def get_data(symbols, date_from \\ nil) do
    res = symbols
    |> Enum.map(fn symbol ->
      Task.async(fn -> {symbol, WorldTradingData.get_historical_data(symbol, date_from)} end)
    end)
    |> Task.yield_many

    errors = res
    |> Enum.filter(fn {task, result} ->
      case result do
        nil ->
          true
        {:ok, {_, {:err, reason, _}}} ->
          true
        _ -> false
      end
    end)
    |> Enum.map(fn {task, result} ->
      case result do
        nil ->
          {:err, :timeout}
        otherwise -> otherwise
      end
    end)

    if Enum.count(errors) > 0 do
      {:err, errors}
    else
      res = res
      |> Map.new(fn {task, {:ok, {symbol, {:ok, response}}}} ->
        {symbol, response.body["history"]}
      end)
      {:ok, res}
    end
  end
end
