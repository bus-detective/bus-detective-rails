class DepartureSerializer < ApplicationSerializer
  attributes :realtime?, :time, :delay

  has_one :route
  has_one :trip
end

