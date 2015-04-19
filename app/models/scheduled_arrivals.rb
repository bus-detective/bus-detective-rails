class ScheduledArrivals
  def self.for_stop(stop_id)
    new(stop_id).all
  end

  def initialize(stop)
    @stop = stop
  end

  def all
    realtime_arrivals.reject { |ra| ra[:route_id] >= 100 }.map { |ra| Arrival.new(ra) }
  end

  private

  def realtime_arrivals
    @realtime_arrivals ||= Metro::Connection.realtime_arrivals.for_stop(@stop.remote_id)
  end
end
