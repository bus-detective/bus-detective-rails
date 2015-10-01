class Api::ShapesController < ApiController

  def show
    render json: Shape.find_by_id(params[:id])
  end
end

