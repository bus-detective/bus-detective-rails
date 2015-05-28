class StopSearcher
  include ActiveModel::SerializerSupport

  DEFAULT_PER_PAGE = 20

  attr_reader :per_page, :page

  def initialize(params)
    @params = params
    @per_page = params.fetch(:per_page, DEFAULT_PER_PAGE).to_i
    @page = params.fetch(:page, 1).to_i
  end

  def results
    @results ||= paginated_results
  end

  def total_results
    filtered_results.count
  end

  def total_pages
    (total_results.to_f / per_page).ceil
  end

  def offset
    per_page * (page - 1)
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

  def paginated_results
    @paginated_results ||= filtered_results.offset(offset).limit(per_page)
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

