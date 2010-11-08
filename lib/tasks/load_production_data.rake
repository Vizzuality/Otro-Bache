require 'google/geo'

def encode_text data
  return "'#{data.gsub(/\\/, '\&\&').gsub(/'/, "''")}'"
end

namespace :otrobache do

  desc 'Load production data'
  task :load_production_data => :environment do
  
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")

    ft = GData::Client::FusionTables.new
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")
    ft.clientlogin(config["google_username"], config["google_password"])

    my_table = ft.show_tables[1]
    
    ftpotholes = my_table.select "*", "ORDER BY reported_date"

    ftpotholes.each do | ftpothole |

      res           = Geokit::Geocoders::GoogleGeocoder.reverse_geocode(ftpothole[:lat]+','+ftpothole[:lon])
      country_name = res.country           || ''
      country_code = res.country_code      || ''
      address      = res.full_address      || ''
      addressline  = res.street_address    || ''
      city_name    = res.city              || ''
      zip          = res.zip               || ''

      if zip.blank?
        zip = "N/A"
      end

      country = Country.find_or_create_by_code(country_code, :name => country_name)
      
      if !city_name.blank?
        
        city = City.find_or_create_by_name(city_name.downcase, :country_id => country.id)
      
        address      = address.gsub(",","|")
        addressline  = addressline.gsub(",","|")
        #reported_date = ftpothole[:reported_date].strftime("%m/%d/%y %H:%M:%S")

        print "country: " + country_name + " city: " + city_name
        
        # Change depending on date format
        # For ruby 1.9.2
        # reported_date = Time.strptime(ftpothole[:reported_date], 
        #                       "%m/%d/%y %H:%M:%S")
        # For ruby 1.8.7
      
        print " saving->" + ftpothole[:lat] + " " + ftpothole[:lon] + " " + ftpothole[:reported_date]
                      
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

        # --------------
        # Fusion Tables
        # sql = "insert into 272266 ('lat', 'lon', 'address', 'addressline',
        #                           'city', 'country','country_code', 'zip', 'reported_by', 'reported_date')
        #               values ('#{ftpothole[:lat]}', '#{ftpothole[:long]}', #{encode_text(address)}, #{encode_text(addressline)},
        #                       #{encode_text(city.name)},
        #                       #{encode_text(country.name)},#{encode_text(country.code)}, #{encode_text(zip)},
        #                       'web', '#{reported_date}')"
        # ft.sql_post(sql)
        # sleep(20)
        # ---------------------

        print " pothole saved\n"
      else
        print "pothole NOT SAVED - " + ftpothole[:lat] + " " + ftpothole[:lon] + " " + ftpothole[:reported_date]
      end
    end
  end
end