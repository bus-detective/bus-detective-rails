class Api::RoutesController < ApiController
  def index
    routes = Route.includes(:agency)

    render json: sort_routes(routes), each_serializer: RouteWithAgencySerializer
  end

  private

  def sort_routes(routes)
    routes.sort_by { |r| r.short_name.to_i }
  end
end
