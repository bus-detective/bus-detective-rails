class Api::StopTimesController < ApiController
  def index
    fetcher = ScheduledDepartureFetcher.new(agency, route, stop)
    if fetcher.valid?
      render json: fetcher, serializer: DepartureFetcherSerializer
    else
      render json: { errors: "Invalid parameters" }, status: :bad_request
    end
  end

  private

  def stop
    @stop ||= Stop.find_legacy(params[:stop_id])
  end

  def route
    @route ||= Route.find(params[:route_id])
  end

  def agency
    return nil unless stop
    @agency ||= stop.agency
  end
end

