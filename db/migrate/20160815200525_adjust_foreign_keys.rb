class AdjustForeignKeys < ActiveRecord::Migration
  def up
    remove_foreign_key :trips, :routes
    add_foreign_key :trips, :routes, on_delete: :cascade
  end

  def down
    remove_foreign_key :trips, :routes
    add_foreign_key :trips, :routes
  end
end
