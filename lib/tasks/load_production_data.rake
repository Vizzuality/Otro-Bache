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
			city = City.find_or_create_by_name(ftpothole[:city], :country_id => country.id)
			
			# Change depending on date format
			reported_date = Time::parse(ftpotholes[1][:reported_date][3..5]+ftpotholes[1][:reported_date][0..2]+"20"+ftpotholes[1][:reported_date][6..7]+ftpotholes[1][:reported_date][8..16]) 
		
			pothole = Pothole.new(:lat => ftpothole[:lat], :lon => ftpothole[:lon], :reported_date => reported_date, :reported_by => ftpothole[:reported_by], :address => ftpothole[:address], :addressline => ftpothole[:addressline], :city => city, :zip => ftpothole[:zip], :country => country)
			pothole.save
			print "pothole saved\n"
		end
	end
end