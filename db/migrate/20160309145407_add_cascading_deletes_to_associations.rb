class AddCascadingDeletesToAssociations < ActiveRecord::Migration
  def change
    remove_foreign_key :trips, :services
    add_foreign_key :trips, :services, on_delete: :cascade
  end
end
