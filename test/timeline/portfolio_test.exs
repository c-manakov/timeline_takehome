defmodule Timeline.PortfolioTest do
  use ExUnit.Case, async: true
  import Timeline.Portfolio

  test "get data" do
    {:ok, data} = get_data(["AAPL", "GOOGL", "VTI"])
    assert %{"GOOGL" => google_data, "AAPL" => apple_data, "VTI" => vti_data} = data
  end

  test "get data with errors" do
    {:err, errors} = get_data(["AAPL", "oops", "wrong"])
    assert Enum.count(errors) == 2
  end
 end
