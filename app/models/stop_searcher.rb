class StopSearcher
  include ActiveModel::SerializerSupport
  DEFAULT_PER_PAGE = 20

  def initialize(params)
    @params = params
  end

  def results
    @results ||= paginated_results
  end

  def per_page
    @params[:per_page] || DEFAULT_PER_PAGE
  end

  def total_results
    filtered_results.count
  end

  def total_pages
    total_results / per_page
  end

  def page
    @params[:page] || 1
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

  def paginated_results
    @paginated_results ||= filtered_results.offset(offset).limit(per_page)
  end

  def filtered_results
    scope = Stop.includes(:routes)

    if @params[:query]
      scope = scope.where("name ILIKE ?", "%#{@params[:query]}%")
    end

    if @params[:longitude] && @params[:latitude]
      scope = scope.by_distance(origin: [@params[:latitude], @params[:longitude]]).limit(20)
    end

    scope
  end
end
