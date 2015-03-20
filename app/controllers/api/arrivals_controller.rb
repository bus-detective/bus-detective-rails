class Api::ArrivalsController < ApplicationController
  def show
    arrivals = ScheduledArrivals.for_stop(params[:id]).sort_by { |a| a.time }
    render json: arrivals
  end
end
