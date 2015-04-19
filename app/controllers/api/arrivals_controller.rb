class Api::ArrivalsController < ApplicationController
  def show
    arrivals = ScheduledArrivals.for_stop(stop).sort_by { |a| a.time }
    render json: arrivals
  end

  def stop
    # Support legacy ids. remote_id will be sent if the user has an old favorite saved
    Stop.where(id: params[:id]).first || Stop.find_by(remote_id: params[:id])
  end
end
