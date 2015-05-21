class RenameAgenciesRealtimeEndpointToGtfsTripUpdate < ActiveRecord::Migration
  def change
    rename_column :agencies, :realtime_endpoint, :gtfs_trip_updates_url
    add_column :agencies, :gtfs_vehicle_positions_url, :string, limit: 150
    add_column :agencies, :gtfs_service_alerts_url, :string, limit: 150
  end
end
