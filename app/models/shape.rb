class Shape < ActiveRecord::Base
  belongs_to :agency
  has_many :trips
  has_many :shape_points, dependent: :destroy
end
