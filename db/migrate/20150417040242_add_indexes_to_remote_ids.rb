class AddIndexesToRemoteIds < ActiveRecord::Migration
  def change
    add_index :trips, [:remote_id, :agency_id]
    add_index :routes, [:remote_id, :agency_id]
    add_index :stops, [:remote_id, :agency_id]
    add_index :agencies, :remote_id
  end
end
