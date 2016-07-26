class AddDisplayNameToAgency < ActiveRecord::Migration
  def change
    add_column :agencies, :display_name, :string, default: "", null: false
  end
end
