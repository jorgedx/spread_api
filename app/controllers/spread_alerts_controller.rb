class SpreadAlertsController < ApplicationController

  def index
    market = spread_alert_params[:market]
    spreads = SpreadAlert.latest_alerts
    spreads = spreads.where(market: market) if market
    latest_spreads = {}
    spreads.each do |spread|
      latest_spreads[spread.market] ||= spread.spread_value
    end
    render json: latest_spreads, status: :ok
  end

  def create
    @spread_alert = SpreadAlert.new(spread_alert_params)
    if @spread_alert.save
      spread_alert = @spread_alert.serializable_hash(only: [:market, :spread_value])
      render json: { message: "Spread Alert created!", spread_alert: spread_alert }, status: :created
    else
      render json: { errors: "Error when create alert." }, status: :unprocessable_entity
    end
  end

  def pooling
    market = spread_alert_params[:market]
    if market.blank?
      render json: { errors: "Market not provided." }, status: :unprocessable_entity
      return
    end

    spread_alert = SpreadAlert.by_market.find_by(market: market)
    if spread_alert.nil?
      render json: { errors: "Alert not found for market." }, status: :not_found
      return
    end

    current_buda_spread = BudaService.new.markets_spreads(market)
    result = compare_spreads(spread_alert.spread_value, current_buda_spread[market])

    render json: {
      market_id: market,
      alert_value: spread_alert.spread_value,
      current_buda_spread: current_buda_spread,
      result: result
    }
  end

  private

  def compare_spreads(spread_alert_value, current_buda_spread )
    # comparision logic
    # 1 <=> 0  1 <=> 1  1 <=> 2
    # => 1     => 0     => -1
    spread_alert_value.to_f <=> current_buda_spread.to_f
  end

  def spread_alert_params
    params.permit(:market, :spread_value)
  end
end
