defmodule Timeline.PortfolioTest do
  use ExUnit.Case, async: true
  import Timeline.Portfolio

  # test "get data" do
  #   {:ok, data} = get_data(["AAPL", "GOOGL", "VTI"], ~D(2005-10-10))
  #   assert {~D[2005-10-10], %{"AAPL" => _, "GOOGL" => _, "VTI" => _}} = hd(data)
  # end

  # test "get data with errors" do
  #   {:err, errors} = get_data(["AAPL", "oops", "wrong"])
  #   assert Enum.count(errors) == 2
  # end

  test "allocate portfolio" do
    portfolio = allocate_portfolio(1000,
      %{"AAPL" => 50, "GOOGL" => 25, "VTI" => 25}, %{"AAPL" => 1, "GOOGL" => 1, "VTI" => 1})
    assert %{"AAPL" => 500.0, "GOOGL" => 250.0, "VTI" => 250.0} = portfolio
  end

  test "calculate portfolio value" do
    portfolio = allocate_portfolio(1000,
      %{"AAPL" => 50, "GOOGL" => 25, "VTI" => 25}, %{"AAPL" => 1, "GOOGL" => 1, "VTI" => 1})
    portfolio_value = calculate_portfolio_value(portfolio, %{"AAPL" => 2, "GOOGL" => 2, "VTI" => 2})
    assert portfolio_value == 2000
  end

  test "calculate portfolio values" do
    {:ok, portfolio_values, _} = calculate_portfolio_values(1000,
      %{"AAPL" => 50, "GOOGL" => 25, "VTI" => 25}, ~D[2005-10-10])
    assert %{date: ~D[2005-10-10], value: _, portfolio: _, values: _} = hd(portfolio_values)
  end

  test "calculate portfolio values with errors" do
    {:err, errors} = calculate_portfolio_values(1000,
      %{"AAPL" => 50, "GOOGLSdas1321" => 25, "VTI" => 25}, ~D[2005-10-10])

    assert Enum.count(errors) == 1
  end
 end
