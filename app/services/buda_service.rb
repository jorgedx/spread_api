class BudaService
  include HTTParty
  base_uri 'https://www.buda.com/api/v2'

  def markets_spreads(market = nil)
    threads = []

    spreads = {}
    markets = market.present? ? [market] : markets_ids

    markets.each do |market|
      threads << Thread.new do
        response = request_order_book market

        if response.success?
          orders = response.parsed_response['order_book']
          asks = orders['asks'] # Ventas
          bids = orders['bids'] # Compras
          minor_asks_red_list = asks.present? ? asks.first[0].to_f : nil
          mayor_bid_green_list = bids.present? ? bids.first[0].to_f : nil
          if minor_asks_red_list.nil? || mayor_bid_green_list.nil?
            spread = "no_data_available"
          else
            spread  = minor_asks_red_list - mayor_bid_green_list
          end
          spreads[market] = spread
        else
          Rails.logger.error "Error when get spread for #{market}: #{response.code}"
        end
      end
    end
    threads.each(&:join)
    spreads.sort.to_h
  end

  def markets_ids
    response = self.class.get('/markets')
    if response.success?
      data = response.parsed_response
      return data['markets'].pluck('id')
    else
      Rails.logger.error "Get markets error: #{response.code}"
      []
    end
  end

  def request_order_book market
     self.class.get("/markets/#{market}/order_book")
  end
end