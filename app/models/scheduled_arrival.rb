class ScheduledArrival
  def self.search(stop_id, time = Time.now)
    stop_times = StopTime.where(stop_id: stop_id)
    stop_times.map { |st| new(st) }
  end

  def initialize(stop_time)
    @stop_time = stop_time
  end

  def time
    @stop_time.arrival_time
  end

  def route_id
    @stop_time.trip.route_id
  end
end
