class DepartureFetcher
  include ActiveModel::SerializerSupport

  attr_reader :agency, :stop, :time
  def initialize(agency, stop, time, params = {})
    @agency = agency
    @time = time.in_time_zone
    @stop = stop
  end

  def departures
    @departures ||= stop_times.map { |stop_time|
      Departure.new(date: @time.to_date, stop_time: stop_time, stop_time_update: nil)
    }.sort_by(&:time)
  end

  def stop_times
    @stop_times ||= agency.stop_times
      .between(start_time, end_time)
      .where(stop: stop, trips: { service_id: agency.services.for_time(@time) })
      .includes(:trip)
      .to_a
  end

  def valid?
    @agency.present? && @stop.present?
  end

  protected

  def start_time
    @time - 10.minutes
  end

  def end_time
    @time + 1.hour
  end
end

