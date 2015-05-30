class StopSearcher
  include ActiveModel::SerializerSupport

  attr_reader :per_page, :page

  def initialize(params)
    @params = params
    @per_page = params.fetch(:per_page, Kaminari.config.default_per_page).to_i
    @page = params.fetch(:page, 1).to_i
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
    @per_page > 0 && has_location_or_query?
  end

  private

  def has_location_or_query?
    [
      @params[:query].present?,
      @params[:latitude].present? && @params[:longitude].present?,
    ].any?
  end

  def filtered_results
    scope = Stop.includes(:routes)

    if @params[:query]
      scope = scope.search(TsqueryBuilder.build(@params[:query]))
    end

    if @params[:longitude] && @params[:latitude]
      scope = scope.by_distance(origin: [@params[:latitude], @params[:longitude]])
    end

    scope
  end
end

