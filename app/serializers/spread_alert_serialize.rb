class SpreadAlertSerializer < ActiveModel::Serializer
  attributes :id, :market, :spread_value
end