class CreateSpreadAlerts < ActiveRecord::Migration[7.1]
  def change
    create_table :spread_alerts do |t|
      t.string :market
      t.decimal :spread_value, precision: 20, scale: 10
      t.timestamps
    end
  end
end
