require 'google/geo'

namespace :otrobache do

	desc 'Load production data'
	task :load_production_data => :environment do
	
		config = YAML::load_file("#{Rails.root}/config/credentials.yml")

		ft = GData::Client::FusionTables.new
		ft.clientlogin(config["google_username"], config["google_password"])

		my_table = ft.show_tables[0]
		ftpotholes = my_table.select "*", "ORDER BY reported_date"
      geo = Google::Geo.new "83d63b531d7eb41fbaa916b1bc65ca9a"
      
      ftpotholes.each do | ftpothole |
			country = Country.find_or_create_by_name(ftpothole[:country])
			city = City.find_by_name(ftpothole[:city])
			if (city == nil)
	      	address = geo.locate ftpothole[:city]
				lon = address[0].coordinates[0]
				lat = address[0].coordinates[1]
				city = City.find_or_create_by_name(ftpothole[:city], 
															:country_id => country.id,
															:the_geom => Point.from_x_y(lon,lat))
			end
			# Change depending on date format
			# For ruby 1.9.2
			# reported_date = Time.strptime(ftpothole[:reported_date], 
			# 											"%m/%d/%y %H:%M:%S")
			# For ruby 1.8.7
			reported_date = ftpothole[:reported_date][0..5]+"20"+ftpothole[:reported_date][6..16]
			reported_date = reported_date.to_time			
		
			pothole = Pothole.new(:lat => ftpothole[:lat], :lon => ftpothole[:lon], 
			:reported_date => reported_date, :reported_by => ftpothole[:reported_by], 
			:address => ftpothole[:address], :addressline => ftpothole[:addressline], 
			:city => city, :zip => ftpothole[:zip], :country => country, :user => "fusion_tables",
			:the_geom => Point.from_x_y(ftpothole[:lon].to_f,ftpothole[:lat].to_f)
			)
			pothole.save
			print "pothole saved\n"
		end
	end
end