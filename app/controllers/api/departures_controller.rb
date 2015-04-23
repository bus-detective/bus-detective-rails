class Api::DeparturesController < ApplicationController
  def index
    fetcher = DepartureFetcher.new(params)
    if fetcher.valid?
      render json: fetcher
    else
      render json: { errors: "Invalid parameters" }, status: :bad_request
    end
  end
end
