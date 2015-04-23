class DepartureFetcherSerializer < ActiveModel::Serializer
  root :data
  has_many :departures
end

