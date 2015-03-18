class ScheduledArrivals
  def self.for_stop(stop_id)
    new(stop_id).all
  end

  def initialize(stop_id)
    @stop_id = stop_id
  end

  def all
    realtime_arrivals.map { |ra| Arrival.new(ra) }
  end

  private

  def realtime_arrivals
    @realtime_arrivals ||= Metro::Connection.realtime_arrivals.for_stop(@stop_id)
  end
end
