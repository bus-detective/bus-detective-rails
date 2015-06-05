class TripSearcher < ApplicationSearcher
  def initialize(agency, params)
    super(params)
    @agency = agency
  end

  def valid?
    [
      @params[:route_id].present?,
      @params[:trip_id].present?
    ].any?
  end

  def scoped_results
    scope = Trip.where(agency: @agency)

    if @params[:route_id]
      scope = scope.where(route_id: @params[:route_id])
    end

    if @params[:trip_id]
      scope = scope.where(id: @params[:trip_id])
    end

    # Should order by something  since we're paginating and what the results to
    # be stable.
    scope.order(:service_id, :headsign)
  end
end

