class AddIndexToStopTimes < ActiveRecord::Migration
  def change
    add_index :stop_times, [:agency_id, :stop_id, :trip_id]
  end
end
