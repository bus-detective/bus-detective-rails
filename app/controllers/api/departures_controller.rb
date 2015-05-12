class Api::DeparturesController < ApiController
  def index
    fetcher = departure_fetcher.new(agency, stop, time)
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
    params[:time] ? Time.zone.parse(params[:time]) : Time.current
  end
end
