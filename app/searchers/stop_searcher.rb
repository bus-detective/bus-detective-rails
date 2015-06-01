class StopSearcher < ApplicationSearcher
  def valid?
    [
      @params[:query].present?,
      @params[:latitude].present? && @params[:longitude].present?,
    ].any?
  end

  def scoped_results
    scope = Stop.includes(:routes, :agency)

    if @params[:query]
      scope = scope.search(TsqueryBuilder.build(@params[:query]))
    end

    if @params[:longitude] && @params[:latitude]
      scope = scope.by_distance(origin: [@params[:latitude], @params[:longitude]])
    end

    scope
  end
end

