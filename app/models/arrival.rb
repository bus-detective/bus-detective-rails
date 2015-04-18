class Arrival
  include ActiveModel::SerializerSupport

  def initialize(realtime_arrival)
    @realtime_arrival = realtime_arrival
  end

  delegate :headsign, to: :trip

  def stop_id
    stop.remote_id
  end

  def route_id
    route.remote_id
  end

  def trip_id
    trip.remote_id
  end

  def trip
    @trip ||= Trip.find_or_initialize_by(remote_id: @realtime_arrival[:trip_id])
  end

  def stop
    @stop ||= Stop.find_or_initialize_by(remote_id: @realtime_arrival[:stop_id])
  end

  def route
    @route ||= Route.find_or_initialize_by(remote_id: @realtime_arrival[:route_id])
  end

  def time
    @realtime_arrival[:time]
  end

  def delay
    @realtime_arrival[:delay]
  end
end
