class StopSearcher < ApplicationSearcher
  def initialize(agency, params)
    super(params)
    @agency = agency
  end

  def valid?
    [
      @params[:query].present?,
      @params[:latitude].present? && @params[:longitude].present?,
    ].any?
  end

  def scoped_results
    scope = Stop.where(agency: @agency).includes(:routes, :agency)

    if @params[:query]
      scope = scope.search(TsqueryBuilder.build(@params[:query]))
    end

    if @params[:longitude] && @params[:latitude]
      scope = scope.by_distance(origin: [@params[:latitude], @params[:longitude]])
    end

    # The above two order by rank and distance respectively. In the absence of
    # either of those, we should order by something else since we're paginating
    # and what the results to be stable.
    scope.order(:id)
  end
end

