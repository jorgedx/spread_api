#set initial markets
buda_service = BudaService.new
market_ids = buda_service.markets_ids
market_ids.each do |market_id|
  SpreadAlert.create(market: market_id, spread_value: 0)
end

#