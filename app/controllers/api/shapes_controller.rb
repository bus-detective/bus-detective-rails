class Api::ShapesController < ApiController
  def index
    searcher = ShapeSearcher.new(params)
    if searcher.valid?
      render json: searcher
    else
      render json: { error: "Invalid parameters" }, status: :bad_request
    end
  end

  def show
    render json: Shape.find_by_id(params[:id])
  end
end

