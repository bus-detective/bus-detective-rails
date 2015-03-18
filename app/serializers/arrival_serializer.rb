class ArrivalSerializer < ActiveModel::Serializer
  attributes :stop_id, :route_id, :time, :delay, :headsign

  def headsign
    object.headsign.titleize
  end
end
