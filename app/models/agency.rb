class Agency < ActiveRecord::Base
  has_many :stops
  has_many :calculated_stop_times
  has_many :trips
  has_many :stop_times
  has_many :routes
  has_many :services
  has_many :service_exceptions
  has_many :shapes
  has_many :shape_points, through: :shapes

  def realtime?
    gtfs_trip_updates_url.present?
  end
end
