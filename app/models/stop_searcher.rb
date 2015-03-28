class StopSearcher
  def initialize(params)
    @params = params
  end

  def stops
    @stops ||= filtered_stops
  end

  private

  def filtered_stops
    scope = Stop

    if @params[:name]
      scope = scope.where("name ILIKE ?", "%#{@params[:name]}%")
    end

    if @params[:longitude] && @params[:latitude]
      scope = scope.by_distance(origin: [@params[:latitude], @params[:longitude]]).limit(20)
    end

    scope
  end
end
