FactoryBot.define do
  factory(:spread_alert) do
    market { "BTC-CLP" }
    spread_value { 777.777 }
  end
end