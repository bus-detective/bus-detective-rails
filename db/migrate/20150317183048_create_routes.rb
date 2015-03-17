class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :route_id
      t.string :agency_id
      t.string :short_name
      t.string :long_name
      t.string :description
      t.string :route_type
      t.string :url
      t.string :color
      t.string :text_color

      t.timestamps null: false
    end
  end
end
