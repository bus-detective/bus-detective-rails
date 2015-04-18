class Api::StopsController < ApplicationController
  def index
    params[:query] = params[:name] if params[:name].present?
    searcher =  StopSearcher.new(params)
    if searcher.valid?
      render json: searcher.results
    else
      render json: { errors: "Invalid parameters" }, status: :bad_request
    end
  end
end
