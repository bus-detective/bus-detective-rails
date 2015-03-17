class CreateStopTimes < ActiveRecord::Migration
  def change
    create_table :stop_times do |t|
      t.integer :trip_id
      t.time :arrival_time
      t.time :departure_time
      t.string :stop_id
      t.string :stop_sequence
      t.string :stop_headsign
      t.integer :pickup_type
      t.integer :drop_off_type
      t.float :shape_dist_traveled

      t.timestamps null: false
    end
  end
end
