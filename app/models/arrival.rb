class Arrival
  include ActiveModel::SerializerSupport

  def initialize(realtime_arrival)
    @realtime_arrival = realtime_arrival
  end

  delegate :stop_id, to: :stop
  delegate :trip_id, :headsign, to: :trip
  delegate :route_id, to: :route

  def trip
    @trip ||= Trip.find(@realtime_arrival[:trip_id])
  end

  def stop
    @stop ||= Stop.find(@realtime_arrival[:stop_id])
  end

  def route
    @route ||= Route.find(@realtime_arrival[:route_id])
  end

  def time
    @realtime_arrival[:time]
  end

  def delay
    @realtime_arrival[:delay]
  end
end
