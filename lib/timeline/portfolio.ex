defmodule Timeline.Portfolio do
  alias Timeline.WorldTradingData

  def get_data(symbols, date_from \\ nil) do
    res =
      symbols
      |> Enum.map(fn symbol ->
        Task.async(fn -> {symbol, WorldTradingData.get_historical_data(symbol, date_from)} end)
      end)
      |> Task.yield_many()

    errors =
      res
      |> Enum.filter(fn {_task, result} ->
        case result do
          nil ->
            true

          {:ok, {_, {:err, _reason, _}}} ->
            true

          _ ->
            false
        end
      end)
      |> Enum.map(fn {_task, result} ->
        case result do
          nil ->
            {:err, :timeout}

          otherwise ->
            otherwise
        end
      end)

    if Enum.count(errors) > 0 do
      {:err, errors}
    else
      res =
        res
        # map all correct responses to histories with each entry marked with symbol
        |> Enum.map(fn {_task, {:ok, {symbol, {:ok, response}}}} ->
          response.body["history"]
          |> Enum.map(fn it -> {symbol, it} end)
        end)
        # zip and map from tuples to {date, %{symbol => value}}
        |> Enum.zip()
        |> Enum.map(fn tuple ->
          {_symbol, {date, _}} = elem(tuple, 0)

          values =
            tuple
            |> Tuple.to_list()
            |> Map.new(fn
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

  def calculate_portfolio_values(portfolio, values) do
    Map.merge(portfolio, values, fn _k, stocks, value ->
      Float.floor(stocks * value, 2)
    end)
  end

  def calculate_portfolio_value(portfolio, values) do
    calculate_portfolio_values(portfolio, values)
    |> Enum.reduce(0, fn {_k, val}, acc -> acc + val end)
  end

  def calculate_timeline(amount, percentages, date, recalculate \\ "off") do
    with {:ok, data} <- get_data(Map.keys(percentages), date) do
      {_date, values} = hd(data)
      initial_portfolio = allocate_portfolio(amount, percentages, values)

      {portfolio_values, final_portfolio} =
        data
        |> Enum.map_reduce({initial_portfolio, date}, fn {date, stock_values},
                                                         {portfolio, portfolio_date} ->
          value = calculate_portfolio_value(portfolio, stock_values)

          {portfolio, portfolio_date} =
            cond do
              recalculate == "off" ->
                {portfolio, portfolio_date}

              recalculate == "yearly" and date.year != portfolio_date.year ->
                {allocate_portfolio(value, percentages, stock_values), date}

              recalculate == "monthly" and date.month != portfolio_date.month ->
                {allocate_portfolio(value, percentages, stock_values), date}

              true ->
                {portfolio, portfolio_date}
            end

          data_point = %{
            date: date,
            values: calculate_portfolio_values(portfolio, stock_values),
            value: calculate_portfolio_value(portfolio, stock_values),
            stock_values: stock_values,
            portfolio: portfolio
          }

          {data_point, {portfolio, portfolio_date}}
        end)

      {:ok, portfolio_values, final_portfolio}
    end
  end
end
