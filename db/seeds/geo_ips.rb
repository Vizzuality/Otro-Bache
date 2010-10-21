current_database  = ActiveRecord::Base.connection.current_database
remote_script_zip = 'http://dl.dropbox.com/u/580074/ipinfo.sql.gz'
ipinfo_sql        = "#{Rails.root}/tmp/ipinfo.sql.gz"

# Downloads ipinfo script from dropbox unless it exists in tmp folder
puts ''
puts 'Downloading ipinfo.sql script...'
puts '--------------------------------'
`curl -0 #{remote_script_zip} > #{ipinfo_sql}` unless File.exists?(ipinfo_sql)

# Since we're inserting about 1,4 million records, we drop the geo_ips table indexes, 
# in order to speed up data insertion.
# These indexes are being created afterwards in the ipinfo.sql script
drop_indexes_sentence = <<EOF
  DROP INDEX city_idx;
  DROP INDEX country_name_idx;
  DROP INDEX index_geo_ips_on_ip_start;
  DROP INDEX lower_city_idx;
  DROP INDEX lower_country_name_idx;
EOF
ActiveRecord::Base.connection.execute(drop_indexes_sentence)

if GeoIp.exists?
  puts ''
  puts 'Emptying geo_ips table...'
  puts '-------------------------'
  GeoIp.delete_all
end

# Loads ipinfo sql script into current environment database
puts ''
puts msg = "Loading ipinfo.sql into #{current_database} database."
puts msg.chars.map{'-'}.join
`cat #{ipinfo_sql} | gunzip | psql -Upostgres #{current_database}`

puts ''
puts 'Removing downloaded data...'
puts '---------------------------'
`rm #{ipinfo_sql}`
