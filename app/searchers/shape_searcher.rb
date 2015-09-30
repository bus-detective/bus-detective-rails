class ShapeSearcher < ApplicationSearcher
  def valid?
    [
      @params[:ids].present?,
    ].any?
  end

  def scoped_results
    scope = Shape.includes(:shape_points)

    if @params[:ids]
      scope = scope.where(id: @params[:ids])
    end

    scope
  end
end

