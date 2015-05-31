class Route < ActiveRecord::Base
  has_many :trips, dependent: :destroy
  has_many :route_stops, dependent: :destroy
  has_many :stops, through: :route_stops
  belongs_to :agency
end
