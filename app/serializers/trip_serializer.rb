class TripSerializer < ApplicationSerializer
  attributes :id, :headsign
  has_one :agency
end

