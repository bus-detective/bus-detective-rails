class Shape < ActiveRecord::Base
  belongs_to :agency
  has_many :trips
  has_many :shape_points

  def type
    'LineString'
  end

  def geometry
    read_attribute(:geometry) || RGeo::Cartesian.factory.line_string([])
  end

  def coordinates=(coords)
    factory = RGeo::Cartesian.factory
    pts = coords.map { |p| factory.point(p.first, p.last) }
    self.geometry = factory.line_string(pts)
  end

  def coordinates
    geometry.points.map { |p| [p.x, p.y] }
  end
end
