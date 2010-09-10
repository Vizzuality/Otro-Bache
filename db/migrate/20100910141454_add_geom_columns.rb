class AddGeomColumns < ActiveRecord::Migration
  def self.up
    add_column :potholes, :the_geom, :point, :srid => 4326
    add_index :potholes, :the_geom, :spatial => true
    add_column :cities, :the_geom, :point, :srid => 4326
    add_index :cities, :the_geom, :spatial => true    
  end

  def self.down 
  end
end
