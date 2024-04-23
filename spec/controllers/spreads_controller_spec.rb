require 'rails_helper'
require 'buda_response_examples'

RSpec.describe SpreadsController, type: :controller do
  include_examples 'buda responses'

  describe 'index' do
    let!(:markets_spreads) { markets_spreads_response }

    it 'response with spreads data' do
      get :index
      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      response_keys = body["spreads"].keys
      markets_keys = markets_spreads[:spreads].stringify_keys.keys
      expect(response_keys).to eq(markets_keys)
    end
  end
end