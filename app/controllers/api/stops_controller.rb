class Api::StopsController < ApiController
  def index
    searcher = StopSearcher.new(params)
    if searcher.valid?
      render json: searcher
    else
      render json: { errors: "Invalid parameters" }, status: :bad_request
    end
  end

  def show
    render json: Stop.find_legacy(params[:id])
  end
end
