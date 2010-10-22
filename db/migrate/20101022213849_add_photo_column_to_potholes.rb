class AddPhotoColumnToPotholes < ActiveRecord::Migration
  def self.up
    add_column :potholes, :photo, :string
  end

  def self.down
    remove_column :potholes, :photo
  end
end
