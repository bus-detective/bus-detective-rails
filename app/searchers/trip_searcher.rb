class TripSearcher < ApplicationSearcher
  def valid?
    [
      @params[:route_id].present?,
    ].any?
  end

  def scoped_results
    scope = Trip

    if @params[:route_id]
      scope = scope.where(route_id: @params[:route_id])
    end

    scope
  end
end

