class Api::StopsController < ApplicationController
  def index
    render json: { stops: Stop.where("name ILIKE ?", "%#{params[:name]}%") }
  end
end
