class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.references :agency, index: true
      t.integer :remote_id

      t.boolean :monday, default: false
      t.boolean :tuesday, default: false
      t.boolean :wednesday, default: false
      t.boolean :thursday, default: false
      t.boolean :friday, default: false
      t.boolean :saturday, default: false
      t.boolean :sunday, default: false

      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
