class StopSearcher
  include ActiveModel::SerializerSupport

  attr_reader :per_page, :page

  def initialize(params)
    @params = params
    @per_page = positive_or_default(params[:per_page].to_i, Kaminari.config.default_per_page)
    @page = positive_or_default(params[:page].to_i, 1)
  end

  def results
    @results ||= filtered_results.page(page).per(per_page)
  end

  def total_results
    results.total_count
  end

  def total_pages
    results.total_pages
  end

  def valid?
    [
      @params[:query].present?,
      @params[:latitude].present? && @params[:longitude].present?,
    ].any?
  end

  private

  def positive_or_default(v, d)
    v > 0 ? v : d
  end

  def filtered_results
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

