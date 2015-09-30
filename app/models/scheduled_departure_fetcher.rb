class ScheduledDepartureFetcher
  include ActiveModel::SerializerSupport

  attr_reader :agency, :stop, :route
  def initialize(agency, route, stop)
    @agency = agency
    @route = route
    @stop = stop
  end

  def departures
    @departures ||= stop_times.map { |stop_time|
      Departure.new(stop_time: stop_time, stop_time_update: nil)
    }.sort_by(&:time)
  end

  def stop_times
    @stop_times ||= begin
      agency.calculated_stop_times
        .where(stop: stop, trip: Trip.where(route: route))
        .between(DateTime.current, DateTime.current + 1.day)
        .preload(:stop, :trip, :route)
    end
  end

  def valid?
    @agency.present? && @stop.present? && @route.present?
  end
end

