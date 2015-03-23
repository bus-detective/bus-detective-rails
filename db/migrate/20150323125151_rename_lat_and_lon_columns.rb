class RenameLatAndLonColumns < ActiveRecord::Migration
  def change
    rename_column :stops, :lat, :latitude
    rename_column :stops, :lon, :longitude
  end
end
