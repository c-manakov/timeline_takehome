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
      # map all correct responses to histories with each entry marked with symbol
      |> Enum.map(fn {task, {:ok, {symbol, {:ok, response}}}} ->
        response.body["history"]
        |> Enum.map(fn it -> {symbol, it} end)
      end)
      # zip and map from tuples to {date, %{symbol => value}}
      |> Enum.zip
      |> Enum.map(fn tuple ->
        {_symbol, {date, _}} = elem(tuple, 1)
        values = tuple
        |> Tuple.to_list
        |> Map.new (fn
          {symbol, {_date, %{"close" => close}}} -> {symbol, String.to_float(close)}
        end)
        {date, values}
      end)
      {:ok, res}
    end
  end

  def allocate_portfolio(amount, percentages, values) do
    Map.merge(percentages, values, fn _k, percentage, value ->
      Float.floor(amount * percentage / (100 * value), 2)
    end)
  end

  def calculate_portfolio_value(portfolio, values) do
    Map.merge(portfolio, values, fn _k, stocks, value ->
      Float.floor(stocks*value, 2)
    end)
    |> Enum.reduce(0, fn {_k, val}, acc -> acc + val end)
  end

  def calculate_portfolio_values(amount, percentages, date) do
    case get_data(Map.keys(percentages), date) do
      {:ok, data} ->
        {_date, values} = hd(data)
        initial_portfolio = allocate_portfolio(amount, percentages, values)

        {portfolio_values, final_portfolio} = data
        |> Enum.map_reduce(initial_portfolio, fn {date, values}, portfolio ->
          data_point = %{
            date: date,
            value: calculate_portfolio_value(portfolio, values),
            values: values,
            portfolio: portfolio
          }
          {data_point, portfolio}
         end)
        {:ok, portfolio_values, final_portfolio}
      {:err, errors} ->
        {:err, errors}
    end
  end
end
