class TripSearcher < ApplicationSearcher
  def valid?
    [
      @params[:route_id].present?,
      @params[:trip_id].present?,
      @params[:ids].present?
    ].any?
  end

  def scoped_results
    scope = Trip.includes(:route, :shape)

    if @params[:route_id]
      scope = scope.where(route_id: @params[:route_id])
    end

    # :trip_id is no longer nessessary since we added :ids, but it remains
    # here to support backward compatability with the public API
    if @params[:trip_id]
      scope = scope.where(id: @params[:trip_id])
    end

    if @params[:ids]
      scope = scope.where(id: @params[:ids])
    end

    scope
  end
end

