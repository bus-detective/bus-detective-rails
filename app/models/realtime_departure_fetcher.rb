class RealtimeDepartureFetcher < DepartureFetcher
  include ActiveModel::SerializerSupport

  def departures
    @departures ||= stop_times.map { |stop_time|
      stop_time_update = realtime_updates.for_stop_time(stop_time) if realtime_updates
      Departure.new(stop_time: stop_time, stop_time_update: stop_time_update)
    }.sort_by(&:time).select { |d| active?(d) }
  end

  # Realtime updates may shift the departures into the time window we are
  # asking for. Therefor we need to query further back in time in order capture
  # all the applicable departures.
  def query_start_time
    start_time - 1.hour
  end

  def active?(departure)
    departure.time >= start_time && departure.time <= end_time
  end

  private

  def realtime_updates
    # Non-standard memoization because we want to allow nulls so we don't
    # continually try and call the service
    unless instance_variable_defined?(:@realtime_updates)
      begin
        @realtime_updates = Metro::RealtimeUpdates.fetch(agency)
      rescue Metro::Error => e
        Rails.logger.warn(e)
        Raven.capture_exception(e)
        @realtime_updates = nil
      end
    end

    @realtime_updates
  end
end
