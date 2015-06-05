class Api::ShapesController < ApiController
  include ScopedToAgency

  def show
    render json: Shape.where(agency: @agency, id: params[:id]).first
  end
end

