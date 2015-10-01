class Api::DeparturesController < ApiController
  def index
    fetcher = departure_fetcher.new(
      agency: agency,
      stop: stop,
      start_time: start_time,
      end_time: end_time
    )

    if fetcher.valid?
      render json: fetcher, serializer: DepartureFetcherSerializer
    else
      render json: { errors: "Invalid parameters" }, status: :bad_request
    end
  end

  private

  def departure_fetcher
    @departure_fetcher ||= if agency && agency.realtime?
                             RealtimeDepartureFetcher
                           else
                             DepartureFetcher
                           end
  end

  def stop
    @stop ||= Stop.find_legacy(params[:stop_id])
  end

  def agency
    return nil unless stop
    @agency ||= stop.agency
  end

  def time
    # TODO: Confirm how time is being passed. We need it in local time for
    # offset to work correctly I think.
    params[:time] ? Time.zone.parse(params[:time]) : Time.current
  end

  def start_time
    time - 10.minutes
  end

  def end_time
    time + duration_in_hours
  end

  DEFAULT_DURATION_IN_HOURS = 1

  def duration_in_hours
    params.fetch(:duration, DEFAULT_DURATION_IN_HOURS).to_i.hours
  end
end
