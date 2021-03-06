class CreatePotholes < ActiveRecord::Migration
  def self.up
    create_table :potholes do |t|
      t.float :lat
      t.float :lon
      t.datetime :reported_date
      t.string :reported_by
      t.string :address
      t.string :addressline
      t.string :zip
      t.string :user
      t.references :city
      t.references :country
      t.timestamps
    end
  end

  def self.down
    drop_table :potholes
  end
end
