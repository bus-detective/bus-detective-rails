class AddRemoteIdAndAgencyToStops < ActiveRecord::Migration
  def change
    rename_column :stops, :stop_id, :remote_id
    add_reference :stops, :agency, index: true
  end
end
