class Shape < ActiveRecord::Base
  belongs_to :agency
  has_many :trips
  has_many :shape_points, dependent: :destroy

  def type
    'LineString'
  end

  def coordinates
    shape_points.order(:sequence).map { |sp| [sp.latitude, sp.longitude] }
  end
end
