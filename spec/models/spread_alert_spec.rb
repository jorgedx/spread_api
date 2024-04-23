require 'rails_helper'

RSpec.describe SpreadAlert, type: :model do
  describe "validations" do
    it "with valid data." do
      spread_alert = SpreadAlert.new(market: "BTC-CLP", spread_value: 777.0)
      expect(spread_alert).to be_valid
    end

    it "with valid data and negative spread." do
      spread_alert = SpreadAlert.new(market: "BTC-CLP", spread_value: -777.0)
      expect(spread_alert).to be_valid
    end

    it "without market." do
      spread_alert = SpreadAlert.new(spread_value: 777)
      expect(spread_alert).not_to be_valid
    end

    it "invalid without spread value" do
      spread_alert = SpreadAlert.new(market: "BTC-CLP")
      expect(spread_alert).not_to be_valid
    end

    it "invalid when bad market value." do
      spread_alert = SpreadAlert.new(market: "BTC", spread_value: 777)
      expect(spread_alert).not_to be_valid
    end

    it "invalid when bad spread value given." do
      spread_alert = SpreadAlert.new(market: "BTC-CLP", spread_value: "invalid")
      expect(spread_alert).not_to be_valid
    end
  end

end
