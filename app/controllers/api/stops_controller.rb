class Api::StopsController < ApplicationController
  def index
    render json: { stops: Metro::Stops.search(params[:name]) }
  end
end
