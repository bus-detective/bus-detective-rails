class ConvertShapePointsToGeo < ActiveRecord::Migration
  def up
    enable_extension "postgis"
    add_column :shapes, :geometry, :line_string, geographic: true
    Shape.find_each do |shape|
      shape.coordinates = shape.shape_points.order(:sequence).map { |point| [point.latitude, point.longitude] }
      shape.save!
    end
    drop_table :shape_points
  end

  def down
    create_table :shape_points do |t|
      t.references :shape, index: true, foreign_key: true
      t.float :latitude
      t.float :longitude
      t.integer :sequence
      t.float :distance_traveled

      t.timestamps null: false
    end
    Shape.find_each do |shape|
      shape.geometry.points.each_with_index do |point, idx|
        ShapePoint.create!(shape: shape, latitude: point.x, longitude: point.y, sequence: idx + 1)
      end
    end
    remove_column :shapes, :geometry
    disable_extension "postgis"
  end
end
