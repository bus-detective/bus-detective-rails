class Api::TripsController < ApiController
  include ScopedToAgency

  def index
    searcher = TripSearcher.new(@agency, params)
    if searcher.valid?
      render json: searcher
    else
      render json: { errors: "Invalid parameters" }, status: :bad_request
    end
  end
end
