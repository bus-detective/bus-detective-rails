class AddRemoteIdAndAgencyToRoutes < ActiveRecord::Migration
  def change
    rename_column :routes, :route_id, :remote_id
    remove_column :routes, :agency_id, :string
    add_reference :routes, :agency, index: true
  end
end
