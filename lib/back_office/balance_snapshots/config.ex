defmodule BackOffice.BalanceSnapshots.Config do
  defstruct ~w(
    enabled
    boot_delay_ms
    every_ms
    after_snapshot
    btc_usd_venue
    btc_usd_symbol
    usd_quote_venue
    usd_quote_asset
  )a
  use Vex.Struct
  alias __MODULE__

  @type venue_id :: Tai.Venues.Adapter.venue_id()
  @type product_symbol :: Tai.Venues.Product.symbol()
  @type t :: %Config{
          enabled: boolean,
          boot_delay_ms: non_neg_integer(),
          every_ms: non_neg_integer,
          after_snapshot: (balance :: term -> term),
          after_snapshot: function,
          btc_usd_venue: venue_id,
          btc_usd_symbol: product_symbol,
          usd_quote_venue: venue_id,
          usd_quote_asset: atom
        }

  validates(:enabled, inclusion: [true, false])
  validates(:btc_usd_venue, presence: true)
  validates(:btc_usd_symbol, presence: true)
  validates(:usd_quote_venue, presence: true)
  validates(:usd_quote_asset, presence: true)

  @default_boot_delay_ms 60_000
  @default_every_ms 60_000

  def parse(env \\ Application.get_env(:back_office, :balance_snapshot)) do
    config = %Config{
      enabled: Map.get(env, :enabled),
      boot_delay_ms: Map.get(env, :boot_delay_ms, @default_boot_delay_ms),
      every_ms: Map.get(env, :every_ms, @default_every_ms),
      after_snapshot: Map.get(env, :after_snapshot, fn _balance -> nil end),
      btc_usd_venue: Map.get(env, :btc_usd_venue),
      btc_usd_symbol: Map.get(env, :btc_usd_symbol),
      usd_quote_venue: Map.get(env, :usd_quote_venue),
      usd_quote_asset: Map.get(env, :usd_quote_asset)
    }

    if Vex.valid?(config) do
      {:ok, config}
    else
      errors = Vex.errors(config)
      {:error, errors}
    end
  end
end
