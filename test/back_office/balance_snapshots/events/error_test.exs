defmodule BackOffice.BalanceSnapshots.Events.ErrorTest do
  use ExUnit.Case, async: true

  test ".to_data/1 transforms reason to a string" do
    event = %BackOffice.BalanceSnapshots.Events.Error{
      reason: [{:market_quote_not_found, :btc_usd}]
    }

    assert Tai.LogEvent.to_data(event) == %{
             reason: "[market_quote_not_found: :btc_usd]"
           }
  end
end
