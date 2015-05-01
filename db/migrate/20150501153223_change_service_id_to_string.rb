class ChangeServiceIdToString < ActiveRecord::Migration
  def up
    change_column :services, :remote_id, :string
  end

  def down
    change_column :services, :remote_id, 'integer USING CAST(column_name AS integer)'
  end
end
