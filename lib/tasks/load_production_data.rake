namespace :otrobache do

	desc 'Load production data'
	task :load_production_data => :environment do
	
		config = YAML::load_file("#{Rails.root}/config/credentials.yml")

		ft = GData::Client::FusionTables.new
		ft.clientlogin(config["google_username"], config["google_password"])

		my_table = ft.show_tables[0]
		ftpotholes = my_table.select "*", "ORDER BY reported_date"
  
		ftpotholes.each do | ftpothole |
			country = Country.find_or_create_by_name(ftpothole[:country])
			city = City.find_or_create_by_name(ftpothole[:city], :country_id => country.id,:the_geom => Point.from_x_y(0,0))
			
			# Change depending on date format
			reported_date = Time::strptime(ftpothole[:reported_date], "%m/%d/%y %H:%M:%S")
		
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