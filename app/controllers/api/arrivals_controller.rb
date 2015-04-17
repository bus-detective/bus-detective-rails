class Api::ArrivalsController < ApplicationController
  def show
    stop = Stop.find_by(remote_id: params[:id])
    arrivals = ScheduledArrivals.for_stop(stop).sort_by { |a| a.time }
    render json: arrivals
  end
end
