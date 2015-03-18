class ScheduledArrivals
  def self.for_stop(stop_id)
    new(stop_id).all
  end

  def initialize(stop_id)
    @stop_id = stop_id
  end

  def all
    realtime_arrivals.map { |ra|
      ra[:trip] = Trip.find_by(trip_id: ra[:trip_id])
      ra
    }
  end

  private

  def realtime_arrivals
    @realtime_arrivals ||= Metro::Connection.arrivals.for_stop(@stop_id)
  end
end
