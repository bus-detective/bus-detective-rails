class CreateRouteStops < ActiveRecord::Migration
  def change
    create_table :route_stops do |t|
      t.integer :route_id, null: false
      t.integer :stop_id, null: false
    end

    add_index :route_stops, [:stop_id, :route_id], unique: true
  end
end
