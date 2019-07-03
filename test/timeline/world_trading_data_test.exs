defmodule Timeline.WorldTradingDataTest do
  use ExUnit.Case, async: true
  import Timeline.WorldTradingData

  test "Get Apple stock historical data without a date" do
    {:ok, response} = get_historical_data("AAPL")
    assert response.status == 200
    history = response.body["history"]
    assert {~D[1980-12-12], _} = List.first(history)
  end

  test "Get Apple stock historical data with date from" do
    {:ok, response} = get_historical_data("AAPL", ~D[2000-01-01])
    assert response.status == 200
    history = response.body["history"]
    assert {~D[2000-01-03], _} = List.first(history)
  end


  test "Return error on incorrect stock" do
    {:err, reason, symbol} = get_historical_data("something")
    assert symbol == "something"
    assert reason =~ "not be found"
  end
end
