require 'rails_helper'
require 'buda_response_examples'

RSpec.describe SpreadAlertsController, type: :controller do
  include_examples 'buda responses'

  describe 'get index' do
    context "responses with wrong data" do
      it 'return empty array when no alerts set' do
        get :index
        expect(body).to eq({})
      end

      it 'return empty array when bad market' do
        get :index, params: {market_id: "CCC-LLL"}
        expect(body).to eq({})
      end
    end
  end

  describe "responses with correct data" do
    context "spreads alerts" do
      let!(:first_market) { 'BTC-CLP' }
      let!(:second_market) { 'ETH-CLP' }
      let!(:third_market) {"ETH-ARS"}
      let!(:btc_clp_alert) { FactoryBot.create(:spread_alert, market: first_market, spread_value: 100) }
      let!(:eth_clp_alert) { FactoryBot.create(:spread_alert, market: second_market, spread_value: 1000) }
      let!(:eth_ars_alert) { FactoryBot.create(:spread_alert, market: third_market, spread_value: 1000) }

      it 'returns all markets information' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(body.keys).to include(first_market, second_market, third_market)
        total_spread = body.values.map { |val| val.to_f }.sum
        spread_sum = SpreadAlert.sum(:spread_value).to_f
        expect(total_spread).to eq(spread_sum)
      end

      it 'returns specific market spread alert ' do
        params = { market: second_market}
        get :index, params: params
        binding.pry
        expect(response).to have_http_status(:ok)
        expect(body.keys[0]).to eq(eth_clp_alert.market)
        expect(body.values[0].to_f).to eq(eth_clp_alert.spread_value.to_f)
      end
    end
  end

  describe 'create spread alerts' do
    context 'with valid params' do
      let!(:valid_params)  do
        { market: 'BTC-CLP', spread_value: 100 }
      end
      it ' create a spread alert' do
        expect {
          post :create, params: valid_params
        }.to change(SpreadAlert, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(body).to include('message')

      end
    end

    context 'with invalid parameters' do
      let!(:invalid_params) do
        { market: nil, spread_value: nil }
      end
      it 'returns unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(body).to include('errors')
      end
    end
  end


  describe 'pooling spread alerts' do
    let(:market) { 'BTC-CLP' }
    let!(:spread_alert) { FactoryBot.create(:spread_alert, market: market, spread_value: 100) }
    let(:current_spread) { 120 }
    context 'with valid params' do
      it 'returns the comparison result' do
        get :pooling, params: { market: market }
        expect(response).to have_http_status(:ok)
        expect(body['market_id'].present?).to eq(true)
        expect(body['alert_value'].present?).to eq(true)
        expect(body['current_buda_spread'].present?).to eq(true)
        expect(body['result'].present?).to eq(true)
      end

      it 'returns positive when alert greater than buda spread' do
        spread_alert.update!(spread_value: 999999999)
        get :pooling, params: { market: market }
        expect(response).to have_http_status(:ok)
        spread_alert_value = body['alert_value'].to_f
        spread_buda_value = body['current_buda_spread'].to_f
        spread_difference = spread_alert_value - spread_buda_value
        expect(spread_difference > 0).to eq(true)
      end

      it 'returns negative when buda spread greater than alert' do
        spread_alert.update!(spread_value: -999999999)
        get :pooling, params: { market: market }
        expect(response).to have_http_status(:ok)
        spread_alert_value = body['alert_value'].to_f
        spread_buda_value = body['current_buda_spread'].to_f
        spread_difference = spread_alert_value - spread_buda_value
        expect(spread_difference < 0).to eq(true)
      end

      xit 'returns 0 when alert equals to alert' do
        spread_alert.update!(spread_value: -0)
        get :pooling, params: { market: market }
        body['current_buda_spread'] = 0
        spread_alert_value = body['alert_value'].to_f
        spread_buda_value = body['current_buda_spread'].to_f
        spread_difference = spread_alert_value - spread_buda_value
        expect(response).to have_http_status(:ok)
        expect(spread_difference == 0).to eq(true)
      end
    end
  end
end
