class RouteWithAgencySerializer < ApplicationSerializer
  attributes :id, :short_name, :long_name, :color, :text_color, :agency_name

  def agency_name
    object.agency.display_name
  end
end
