class CreateShapePoints < ActiveRecord::Migration
  def change
    create_table :shape_points do |t|
      t.references :shape, index: true, foreign_key: true
      t.float :latitude
      t.float :longitude
      t.integer :sequence
      t.float :distance_traveled

      t.timestamps null: false
    end
  end
end
