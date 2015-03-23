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
    elsif @params[:longitude] && params[:latitude]
      ""
    end
  end
end
