class AddRemoteIdAndAgencyToTrips < ActiveRecord::Migration
  def change
    rename_column :trips, :trip_id, :remote_id
    add_reference :trips, :agency, index: true
    remove_column :trips, :route_id, :integer
    add_reference :trips, :route, index: true
  end
end
