class DepartureSerializer < ApplicationSerializer
  attributes :realtime?, :time, :delay, :scheduled_time

  has_one :route
  has_one :trip
end

