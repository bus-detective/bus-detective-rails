class Api::DeparturesController < ApiController
  include ScopedToAgency

  def index
    fetcher = departure_fetcher.new(@agency, stop, time)
    if fetcher.valid?
      render json: fetcher, serializer: DepartureFetcherSerializer
    else
      render json: { errors: "Invalid parameters" }, status: :bad_request
    end
  end

  private

  def departure_fetcher
    @departure_fetcher ||= if @agency && @agency.realtime?
                             RealtimeDepartureFetcher
                           else
                             DepartureFetcher
                           end
  end

  def stop
    @stop ||= Stop.where(agency: @agency).find_legacy(params[:stop_id])
  end

  def time
    # TODO: Confirm how time is being passed. We need it in local time for
    # offset to work correctly I think.
    params[:time] ? Time.zone.parse(params[:time]) : Time.current
  end
end
