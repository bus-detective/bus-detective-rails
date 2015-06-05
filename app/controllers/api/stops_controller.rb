class Api::StopsController < ApiController
  include ScopedToAgency
  
  def index
    searcher = StopSearcher.new(@agency, params)
    if searcher.valid?
      render json: searcher
    else
      render json: { errors: "Invalid parameters" }, status: :bad_request
    end
  end

  def show
    render json: Stop.where(agency: @agency).find_legacy(params[:id])
  end
end
