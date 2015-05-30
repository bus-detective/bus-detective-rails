class SetVehiclePositionUrl < ActiveRecord::Migration
  def up
    Agency.where(gtfs_endpoint: "http://www.go-metro.com/uploads/GTFS/google_transit_info.zip").update_all(gtfs_vehicle_positions_url: "http://developer.go-metro.com/TMGTFSRealTimeWebService/vehicle/")
  end
end
