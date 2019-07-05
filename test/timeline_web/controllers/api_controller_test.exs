defmodule TimelineWeb.ApiControllerTest do
  use TimelineWeb.ConnCase

  test "POST /calculate", %{conn: conn} do
    response =
      conn
      |> post(Routes.api_path(conn, :calculate), %{
        "amount" => 1000,
        "date" => "2005-05-05",
        "percentages" => %{
          "AAPL" => 50,
          "GOOGL" => 50
        },
        "rebalanceFrequency" => "off"
      })
      |> json_response(200)

    assert %{"date" => "2005-05-05", "portfolio" => %{"AAPL" => _, "GOOGL" => _}} = hd(response)
  end
end
