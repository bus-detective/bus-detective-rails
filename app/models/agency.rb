class Agency < ActiveRecord::Base
  has_many :stops
  has_many :trips
  has_many :stop_times
  has_many :routes
  has_many :services

  def realtime?
    gtfs_trip_updates_url.present?
  end
end
