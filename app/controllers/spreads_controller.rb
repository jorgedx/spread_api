class SpreadsController < ApplicationController

  def index
    buda_service = BudaService.new
    market = index_params[:market]
    markets_spreads = buda_service.markets_spreads market

    if markets_spreads.nil? || markets_spreads.empty?
      render json: { error: "No markets found from Buda service." }, status: :not_found
      return
    end

    render json: {spreads: markets_spreads}, status: :ok
  end

  private

  def index_params
    params.permit(:market)
  end

end
