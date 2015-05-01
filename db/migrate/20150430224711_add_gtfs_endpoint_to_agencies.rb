class AddGtfsEndpointToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :gtfs_endpoint, :string
  end
end
