class RouteStop < ActiveRecord::Base
  belongs_to :route
  belongs_to :stop

  validates :route, presence: true
  validates :stop, presence: true
  validates_uniqueness_of :route, scope: :stop_id

  def self.update_cache
    transaction do
      connection.execute 'TRUNCATE TABLE route_stops'
      connection.execute <<-SQL
        INSERT INTO route_stops (route_id, stop_id)
          SELECT DISTINCT
            routes.id as route_id, stops.id as stop_id
          FROM
            routes
          INNER JOIN
            trips ON trips.route_id = routes.id
          INNER JOIN
            stop_times ON stop_times.trip_id = trips.id
          INNER JOIN
            stops ON stops.id = stop_times.stop_id
      SQL
    end
  end
end
