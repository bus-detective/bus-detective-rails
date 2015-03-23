class Api::StopsController < ApplicationController
  def index
    render json: StopSearcher.new(params).stops
  end
end
