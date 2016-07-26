class Api::RoutesController < ApiController
  def index
    render json: Route.all, each_serializer: RouteWithAgencySerializer
  end
end
