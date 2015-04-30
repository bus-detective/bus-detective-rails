class ApiController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    render json: { errors: "not found" }, status: 404
  end
end
