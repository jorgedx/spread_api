require 'rails_helper'
require 'buda_response_examples'


RSpec.describe BudaService do
  describe 'BudaService' do
    include_examples 'buda responses'

    let!(:buda_service) { BudaService.new }
    let!(:markets_spreads)  { buda_service.markets_spreads }
    let!(:buda_markets_ids) { buda_service.markets_ids }

    #before :each

    context "get spreads" do
      it "return spreads for all markets" do
        spreads_response = markets_spreads_response[:spreads]
        expect(markets_spreads).to be_a(Hash)

        expect(markets_spreads.keys).to match_array(spreads_response.keys.map(&:to_s))
        expect(markets_spreads.size).to eq(spreads_response.size)

        spreads_response.values.each do |value|
          expect(value).to be_a(Numeric).or(eq("no_data_available"))
        end
      end

      it "returns spreads for specific market" do
        market = markets_spreads_response[:spreads].keys[rand(25)].to_s
        spread = BudaService.new.markets_spreads(market)
        expect(spread.size).to eq(1)
        expect(spread[market]).to be_a(Numeric).or(eq("no_data_available"))
      end
    end

    context "get markets ids" do
      it 'returns list of markets ids' do
        response_markets_ids = buda_markets_response["markets"].map{|market| market["id"]}
        expect(BudaService.new.markets_ids.sort).to eq(response_markets_ids.sort)
      end
    end

    context 'when the request fails' do
      before :each do
        allow(BudaService).to receive(:get).
          with('/markets').
          and_return(double('response', success?: false, code: 500))
      end

      it 'returns an empty array' do
        buda_service = BudaService.new
        market_ids = buda_service.markets_ids
        expect(market_ids).to eq([])
      end
    end

    describe 'test spread result' do
      let!(:buda_service) { BudaService.new }
      let!(:market) { 'BTC-CLP' }
      let!(:order_book) { btc_clp_order_book }
      it 'test spread result' do
        market_id = btc_clp_order_book[:order_book][:market_id]
        ask = order_book[:order_book][:asks][0][0].to_f
        bid = order_book[:order_book][:bids][0][0].to_f
        calculated_spread = ask-bid
        obtained_spread = 100000
        expect(market_id).to eq(market)
        expect(calculated_spread).to eq(obtained_spread)
      end
    end
  end
end