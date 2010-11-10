require 'google/geo'

def encode_text data
  return "'#{data.gsub(/\\/, '\&\&').gsub(/'/, "''")}'"
end

namespace :otrobache do

  desc 'Load production data'
  task :load_production_data => :environment do

    ft = GData::Client::FusionTables.new

    ft.clientlogin(APP_CONFIG[:google_username], APP_CONFIG[:google_password])

    my_table = ft.show_tables[6]

    ftpotholes = my_table.select "*", "ORDER BY reported_date"

    count = 1
    File.open("#{Rails.root}/public/data.csv", 'a') do |f|
      f.puts('lat,lon,address,addressline,city,country,zip,reported_by,reported_date,country_code,pothole_id')
    end

    ftpotholes.each do | ftpothole |

      if ftpothole[:lat].nil? or ftpothole[:lon].nil?

        puts count.to_s + ". pothole NOT SAVED - lat or lon is nil\n"

      else

        res           = Geokit::Geocoders::GoogleGeocoder.reverse_geocode(ftpothole[:lat]+','+ftpothole[:lon])
        country_name = res.country
        country_code = res.country_code
        address      = res.full_address
        addressline  = res.street_address
        city_name    = res.city
        zip          = res.zip

        if country_name.nil? || country_code.nil? || address.nil? || addressline.nil? || city_name.nil? || zip.nil?

          puts count.to_s + ". pothole NOT SAVED - " + ftpothole[:lat] + " " + ftpothole[:lon] + " " + ftpothole[:reported_date] + "\n"

        else

          country = Country.find_or_create_by_code(country_code, :name => country_name)
          city = City.find_or_create_by_name(city_name.downcase, :country_id => country.id)

          address      = address.gsub(",","|")
          addressline  = addressline.gsub(",","|")
          #reported_date = ftpothole[:reported_date].strftime("%m/%d/%y %H:%M:%S")



          # Change depending on date format
          # For ruby 1.9.2
          # reported_date = Time.strptime(ftpothole[:reported_date],
          #                       "%m/%d/%y %H:%M:%S")
          # For ruby 1.8.7

          pothole = Pothole.new(:lat => ftpothole[:lat],
                      :lon => ftpothole[:lon],
                      :reported_date => ftpothole[:reported_date],
                      :reported_by => ftpothole[:reported_by],
                      :address => address,
                      :addressline => addressline,
                      :city => city,
                      :zip => zip,
                      :country => country,
                      :user => "fusion_tables",
                      :the_geom => Point.from_x_y(ftpothole[:lon].to_f,
                                          ftpothole[:lat].to_f))

          pothole.save

          puts count.to_s + ". country: " + country_name + " city: " + city_name + " saving-> " +
                ftpothole[:lat] + " " + ftpothole[:lon] + " " + ftpothole[:reported_date] + " pothole SAVED\n"

        end
      end
      count = count + 1
    end
  end
end