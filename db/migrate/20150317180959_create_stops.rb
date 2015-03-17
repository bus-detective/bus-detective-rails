class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :stop_id
      t.integer :code
      t.string :name
      t.string :description
      t.float :lat
      t.float :lon
      t.integer :zone_id
      t.string :url
      t.integer :location_type
      t.string :parent_station
      t.string :timezone
      t.integer :wheelchair_boarding
    end
  end
end
