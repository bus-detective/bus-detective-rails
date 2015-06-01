class Api::TripsController < ApiController
  def index
    searcher = TripSearcher.new(params)
    if searcher.valid?
      render json: searcher
    else
      render json: { errors: "Invalid parameters" }, status: :bad_request
    end
  end
end
