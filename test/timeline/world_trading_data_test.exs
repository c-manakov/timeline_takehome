defmodule Timeline.WorldTradingDataTest do
  use ExUnit.Case, async: true
  import Timeline.WorldTradingData

  test "Get Apple stock historical data without a date" do
    {:ok, response} = get_historical_data("AAPL")
    assert response.status == 200
  end

  test "Get Apple stock historical data with date from" do
    {:ok, response} = get_historical_data("AAPL", ~D[2000-01-01])
    IO.inspect response
  end
end
