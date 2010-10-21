class CreateGeoIps < ActiveRecord::Migration
  def self.up
    create_table :geo_ips do |t|
      t.integer :ip_start, :limit => 8
      t.string :country_code
      t.string :country_name
      t.string :region_code
      t.string :region_name
      t.string :city
      t.string :zipcode
      t.float :latitude
      t.float :longitude
      t.integer :timezone
      t.integer :gmt_offset
      t.integer :dst_offset
      t.string :city_latin1
      t.timestamps
    end
  end

  def self.down
    drop_table :geo_ips
  end
end
