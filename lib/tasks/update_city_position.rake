require 'google/geo'

def encode_text data
  return "'#{data.gsub(/\\/, '\&\&').gsub(/'/, "''")}'"
end

namespace :otrobache do

  desc 'Update city position'
  task :update_city_position => :environment do

    cities = City.find(:all)
    cities.each do |city|
      temp = Geokit::Geocoders::GoogleGeocoder.geocode(city.name.downcase)
      if (!temp.lng.nil? and !temp.lat.nil?)
        if city.update_attributes(:name => city.name.downcase, :the_geom => Point.from_x_y(temp.lng.to_f, temp.lat.to_f))
          puts "city UPDATED - " + city.name + "\n"
        else
          puts "city NOT UPDATED - " + city.name + " error \n"
        end
      else
        puts "city NOT UPDATED - " + city.name + "\n"
      end
      sleep(5)
    end
  end
end
