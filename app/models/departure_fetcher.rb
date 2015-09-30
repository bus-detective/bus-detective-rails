class DepartureFetcher
  include ActiveModel::SerializerSupport

  attr_reader :agency, :stop, :start_time, :end_time
  def initialize(agency:, stop:, start_time:, end_time:)
    @agency = agency
    @stop = stop
    @start_time = start_time
    @end_time = end_time
  end

  def departures
    @departures ||= stop_times.map { |stop_time|
      Departure.new(stop_time: stop_time, stop_time_update: nil)
    }.sort_by(&:time).select { |d| active?(d) }
  end

  def stop_times
    @stop_times ||= begin
      agency.calculated_stop_times
        .where(stop: stop)
        .between(query_start_time, query_end_time)
        .preload(:stop, :trip, :route)
    end
  end

  def query_start_time
    start_time
  end

  def query_end_time
    end_time
  end

  def valid?
    @agency.present? && @stop.present?
  end

  private

  def active?(departure)
    true
  end
end
