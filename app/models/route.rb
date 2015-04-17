class Route < ActiveRecord::Base
  has_many :trips
  belongs_to :agency
end
