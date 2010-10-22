# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101022213849) do

  create_table "cities", :force => true do |t|
    t.column "name", :string
    t.column "country_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "the_geom", :point, :srid => 4326
  end

  add_index "cities", ["the_geom"], :name => "index_cities_on_the_geom", :spatial=> true 

  create_table "countries", :force => true do |t|
    t.column "name", :string
    t.column "code", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "geo_ips", :force => true do |t|
    t.column "ip_start", :integer, :limit => 8
    t.column "country_code", :string
    t.column "country_name", :string
    t.column "region_code", :string
    t.column "region_name", :string
    t.column "city", :string
    t.column "zipcode", :string
    t.column "latitude", :float
    t.column "longitude", :float
    t.column "timezone", :integer
    t.column "gmt_offset", :integer
    t.column "dst_offset", :integer
    t.column "city_latin1", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "geo_ips", ["city"], :name => "city_idx"
  add_index "geo_ips", ["country_name"], :name => "country_name_idx"
  add_index "geo_ips", ["ip_start"], :name => "index_geo_ips_on_ip_start"


  create_table "potholes", :force => true do |t|
    t.column "lat", :float
    t.column "lon", :float
    t.column "reported_date", :datetime
    t.column "reported_by", :string
    t.column "address", :string
    t.column "addressline", :string
    t.column "zip", :string
    t.column "user", :string
    t.column "city_id", :integer
    t.column "country_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "the_geom", :point, :srid => 4326
    t.column "photo", :string
  end

  add_index "potholes", ["the_geom"], :name => "index_potholes_on_the_geom", :spatial=> true 

end
