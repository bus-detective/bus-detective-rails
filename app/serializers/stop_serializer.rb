class StopSerializer < ActiveModel::Serializer
  attributes :id, :stop_id, :name, :direction

  has_many :routes
end

