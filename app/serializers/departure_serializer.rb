class DepartureSerializer < ActiveModel::Serializer
  attributes :realtime?, :time, :delay
  has_one :route
end

