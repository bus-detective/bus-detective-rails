class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes do |t|
      t.string :remote_id
      t.references :agency, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
