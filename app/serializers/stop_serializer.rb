class StopSerializer < ApplicationSerializer
  attributes :id, :name, :direction, :latitude, :longitude

  has_many :routes
  has_one :agency
end

