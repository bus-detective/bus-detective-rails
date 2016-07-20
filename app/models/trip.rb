class Trip < ActiveRecord::Base
  has_many :stop_times, dependent: :destroy
  belongs_to :route
  belongs_to :agency
  belongs_to :service
  belongs_to :shape
  has_many :shape_points, through: :shape
end
