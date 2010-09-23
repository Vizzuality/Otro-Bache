# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100910141454) do

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
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

# Could not dump table "geography_columns" because of following StandardError
#   Unknown type 'name' for column 'f_table_catalog' /Users/JavierMorales/Workspace/Otro-Bache/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:52:in `table'/Users/JavierMorales/Workspace/Otro-Bache/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:50:in `each'/Users/JavierMorales/Workspace/Otro-Bache/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:50:in `table'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/schema_dumper.rb:72:in `tables'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/schema_dumper.rb:63:in `each'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/schema_dumper.rb:63:in `tables'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/schema_dumper.rb:25:in `dump'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/schema_dumper.rb:19:in `dump'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/railties/databases.rake:295/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/railties/databases.rake:294:in `open'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/railties/databases.rake:294/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:636:in `call'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:636:in `execute'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:631:in `each'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:631:in `execute'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:597:in `invoke_with_call_chain'/Users/JavierMorales/.rvm/rubies/ruby-1.8.7-p302/lib/ruby/1.8/monitor.rb:242:in `synchronize'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:583:in `invoke'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/railties/databases.rake:141/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:636:in `call'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:636:in `execute'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:631:in `each'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:631:in `execute'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:597:in `invoke_with_call_chain'/Users/JavierMorales/.rvm/rubies/ruby-1.8.7-p302/lib/ruby/1.8/monitor.rb:242:in `synchronize'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:583:in `invoke'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:2051:in `invoke_task'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:2029:in `top_level'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:2029:in `each'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:2029:in `top_level'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:2023:in `top_level'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:2001:in `run'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/lib/rake.rb:1998:in `run'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/gems/rake-0.8.7/bin/rake:31/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/bin/rake:19:in `load'/Users/JavierMorales/.rvm/gems/ruby-1.8.7-p302@otrobache/bin/rake:19

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
  end

  add_index "potholes", ["the_geom"], :name => "index_potholes_on_the_geom", :spatial=> true 

end
