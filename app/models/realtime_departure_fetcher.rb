class RealtimeDepartureFetcher < DepartureFetcher
  include ActiveModel::SerializerSupport

  def initialize(agency, stop, time, params = {})
    super(agency, stop, time, params)

    time_limit = params.fetch(:time_limit, 10).to_i
    @active_duration = Interval.new((-1 * time_limit.minutes))
  end

  def departures
    @departures ||= stop_times.map { |stop_time|
      stop_time_update = realtime_updates.for_stop_time(stop_time)
      Departure.new(stop_time: stop_time, stop_time_update: stop_time_update)
    }.sort_by(&:time).select { |d| active?(d) }
  end

  private

  def start_time
    @time - 1.hour
  end

  def active?(departure)
    departure.duration_from(@time) >= @active_duration
  end

  def realtime_updates
    @realtime_updates ||= Metro::RealtimeUpdates.fetch(agency)
  end
end
