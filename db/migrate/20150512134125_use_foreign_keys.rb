class UseForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :route_stops, :routes
    add_foreign_key :route_stops, :stops
    add_foreign_key :routes, :agencies
    add_foreign_key :services, :agencies
    add_foreign_key :stop_times, :agencies
    add_foreign_key :stop_times, :stops
    add_foreign_key :stop_times, :trips
    add_foreign_key :stops, :agencies
    add_foreign_key :trips, :services
    add_foreign_key :trips, :agencies
    add_foreign_key :trips, :routes
  end
end
