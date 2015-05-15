class AddRealtimeEndpointToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :realtime_endpoint, :string
  end
end
