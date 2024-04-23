class SpreadAlert < ApplicationRecord
  validates :market, presence: true, length: { is: 7 }
  validates :spread_value, presence: true, numericality: true

  scope :by_market, -> { self.spreads_by_market }
  scope :latest_alerts, -> {
    select('market, spread_value')
      .order(market: :asc, created_at: :desc)
  }
  def self.spreads_by_market
    select(:market, :spread_value, "MAX(created_at) as last").group(:market)
    # SELECT
    # market, spread_value ,
    # MAX(created_at) as latest_created_at
    # FROM "spread_alerts"
    # GROUP BY "spread_alerts"."market"
  end
end
