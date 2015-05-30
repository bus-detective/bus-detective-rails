class TripSearcher
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
      @params[:route_id].present?,
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
    scope = Trip

    if @params[:route_id]
      scope = scope.where(route_id: @params[:route_id])
    end

    scope
  end
end

