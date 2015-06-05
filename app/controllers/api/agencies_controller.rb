class Api::AgenciesController < ApiController
  def index
    # This should be OK for now since we don't have so many.
    # If we import the whole world, we'll probably want to do geo-location
    # and/or searching by name
    render json: Agency.all
  end

  def show
    render json: Agency.find_by_id(params[:id])
  end
end
