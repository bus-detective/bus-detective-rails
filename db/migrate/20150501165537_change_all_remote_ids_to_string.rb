class ChangeAllRemoteIdsToString < ActiveRecord::Migration
  def up
    change_column :services, :remote_id, :string
    change_column :routes, :remote_id, :string
    change_column :trips, :remote_id, :string
  end

  def down
    change_column :services, :remote_id, 'integer USING CAST(remote_id AS integer)'
    change_column :routes, :remote_id, 'integer USING CAST(remote_id AS integer)'
    change_column :trips, :remote_id, 'integer USING CAST(remote_id AS integer)'
  end
end
