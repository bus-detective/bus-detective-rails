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
      scope = scope.search(substituted_query)
    end

    if @params[:longitude] && @params[:latitude]
      scope = scope.by_distance(origin: [@params[:latitude], @params[:longitude]]).limit(20)
    end

    scope
  end

  def substituted_query
    @params[:query].gsub(/(#{QUERY_SUBSTITUTIONS.keys.join("|")})/, QUERY_SUBSTITUTIONS)
  end

  QUERY_SUBSTITUTIONS = {
    "and" => "&",
    "first" => "1st",
    "second" => "2nd",
    "thrid" => "3rd",
    "fourth" => "4th",
    "fifth" => "5th",
    "sixth" => "6th",
    "seventh" => "7th",
    "eighth" => "8th",
    "ninth" => "9th",
    "tenth" => "10th",
    "eleventh" => "11th",
    "twelfth" => "12th",
  }
end
