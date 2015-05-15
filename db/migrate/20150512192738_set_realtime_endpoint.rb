class SetRealtimeEndpoint < ActiveRecord::Migration
  def up
    Agency.where(gtfs_endpoint: "http://www.go-metro.com/uploads/GTFS/google_transit_info.zip").update_all(realtime_endpoint: "http://developer.go-metro.com/TMGTFSRealTimeWebService/TripUpdate/")
  end
end
