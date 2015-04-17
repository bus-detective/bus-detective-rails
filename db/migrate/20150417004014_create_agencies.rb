class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :remote_id
      t.string :name
      t.string :url
      t.string :fare_url
      t.string :timezone
      t.string :language
      t.string :phone
    end
  end
end
