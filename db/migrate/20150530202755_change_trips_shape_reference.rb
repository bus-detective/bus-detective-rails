class ChangeTripsShapeReference < ActiveRecord::Migration
  def change
    remove_column :trips, :shape_id, :string
    add_reference :trips, :shape, index: true, foreign_key: true
  end
end
