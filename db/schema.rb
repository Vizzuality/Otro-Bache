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
#   Unknown type 'name' for column 'f_table_catalog' ["/Users/jatorre/workspace/Otro-Bache/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:52:in `block in table'", "/Users/jatorre/workspace/Otro-Bache/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:50:in `each'", "/Users/jatorre/workspace/Otro-Bache/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:50:in `table'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/schema_dumper.rb:72:in `block in tables'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/schema_dumper.rb:63:in `each'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/schema_dumper.rb:63:in `tables'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/schema_dumper.rb:25:in `dump'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/schema_dumper.rb:19:in `dump'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/railties/databases.rake:295:in `block (4 levels) in <top (required)>'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/railties/databases.rake:294:in `open'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/railties/databases.rake:294:in `block (3 levels) in <top (required)>'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:636:in `call'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:636:in `block in execute'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:631:in `each'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:631:in `execute'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:597:in `block in invoke_with_call_chain'", "/Users/jatorre/.rvm/rubies/ruby-1.9.2-rc2/lib/ruby/1.9.1/monitor.rb:201:in `mon_synchronize'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:583:in `invoke'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/activerecord-3.0.0.beta4/lib/active_record/railties/databases.rake:141:in `block (2 levels) in <top (required)>'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:636:in `call'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:636:in `block in execute'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:631:in `each'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:631:in `execute'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:597:in `block in invoke_with_call_chain'", "/Users/jatorre/.rvm/rubies/ruby-1.9.2-rc2/lib/ruby/1.9.1/monitor.rb:201:in `mon_synchronize'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:583:in `invoke'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:2051:in `invoke_task'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:2029:in `block (2 levels) in top_level'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:2029:in `each'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:2029:in `block in top_level'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:2023:in `top_level'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:2001:in `block in run'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/lib/rake.rb:1998:in `run'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/gems/rake-0.8.7/bin/rake:31:in `<top (required)>'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/bin/rake:19:in `load'", "/Users/jatorre/.rvm/gems/ruby-1.9.2-rc2@otrobache/bin/rake:19:in `<main>'"]

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
