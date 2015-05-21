class CreateServiceExceptions < ActiveRecord::Migration
  def change
    create_table :service_exceptions do |t|
      t.references :agency
      t.references :service
      t.date :date
      t.integer :exception

      t.timestamps
    end

    add_foreign_key :service_exceptions, :agencies
    add_foreign_key :service_exceptions, :services
  end
end
