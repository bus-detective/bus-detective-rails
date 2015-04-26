class DepartureFetcher
  include ActiveModel::SerializerSupport

  def initialize(params)
    @time = params[:time] ? Time.zone.parse(params[:time]) : Time.current
    @stop_id = params[:stop_id]
  end

  def departures
    @departures ||= stop_times.map { |stop_time|
      stop_time_update = realtime_updates.for_stop_time(stop_time)
      Departure.new(stop_time: stop_time, stop_time_update: stop_time_update)
    }
  end

  def stop_times
    @stop_times ||= StopTime
      .where(stop: stop, trips: { service_id: Service.for_time(@time) })
      .where("departure_time > :start_time AND departure_time < :end_time", time_query)
      .includes(:route)
      .order(:departure_time)
  end

  def valid?
    @stop_id.present?
  end

  private

  def time_query
    {
      start_time: @time - 10.minutes,
      end_time: @time + 1.hour
    }
  end

  def stop
    @stop ||= Stop.find_legacy(@stop_id)
  end

  def realtime_updates
    @realtime_updates ||= Metro::RealtimeUpdates.fetch
  end
end
