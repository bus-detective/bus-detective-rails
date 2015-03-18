class Api::ArrivalsController < ApplicationController
  def show
    render json: ScheduledArrivals.for_stop(params[:id])
  end
end
