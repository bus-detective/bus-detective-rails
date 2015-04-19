class AddRemoteIdAndAgencyToStopTimes < ActiveRecord::Migration
  def change
    add_reference :stop_times, :agency, index: true

    remove_column :stop_times, :stop_id, :integer
    add_reference :stop_times, :stop, index: true

    remove_column :stop_times, :trip_id, :integer
    add_reference :stop_times, :trip, index: true
  end
end
