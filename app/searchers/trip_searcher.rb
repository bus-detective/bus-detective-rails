class TripSearcher < ApplicationSearcher
  def valid?
    [
      @params[:route_id].present?,
      @params[:trip_id].present?
    ].any?
  end

  def scoped_results
    scope = Trip

    if @params[:route_id]
      scope = scope.where(route_id: @params[:route_id])
    end

    if @params[:trip_id]
      scope = scope.where(id: @params[:trip_id])
    end

    scope
  end
end

