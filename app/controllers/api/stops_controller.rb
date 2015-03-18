class Api::StopsController < ApplicationController
  def index
    render json: Stop.where("name ILIKE ?", "%#{params[:name]}%")
  end
end
