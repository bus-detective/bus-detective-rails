class StopSearcher
  include ActiveModel::SerializerSupport

  DEFAULT_PER_PAGE = 20

  attr_reader :per_page, :page

  def initialize(params)
    @params = params
    @per_page = positive_or_default(params[:per_page].to_i, DEFAULT_PER_PAGE)
    @page = positive_or_default(params[:page].to_i, 1)
  end

  def results
    @results ||= paginated_results
  end

  def total_results
    filtered_results.count
  end

  def total_pages
    total_results / per_page
  end

  def offset
    per_page * (page - 1)
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

  def paginated_results
    @paginated_results ||= filtered_results.offset(offset).limit(per_page)
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

