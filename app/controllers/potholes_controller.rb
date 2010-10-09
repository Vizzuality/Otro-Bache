# encoding: utf-8
class PotholesController < ApplicationController

  # define('FLICKR_API_KEY', '83d63b531d7eb41fbaa916b1bc65ca9a');
  # define('FLICKR_API_SECRET', 'e4dac314a1e456af');
  
  
  # GET /potholes
  # GET /potholes.xml
  def index
    
    conn = PGconn.connect( :dbname => 'ipinfo', :user => 'postgres' )
    #If the controller is called without location params we redirect where the user is geolocating its IP
    if (params[:location].nil?)
      #geolocate
      begin
        url_to_redirect="spain"
        result = conn.exec("SELECT * FROM geo_ips where ip_start <= inetmi('#{request.env[:REMOTE_ADDR]}','0.0.0.0') order by ip_start desc limit 1")
        user_location= result.first
        if(user_location['city'].nil? && user_location['country_name'].nil? && user_location['country_name']=="Reserved")
          url_to_redirect = "spain"
        elsif (user_location['city'].nil?)
          url_to_redirect=CGI.escape(user_location['country_name'].downcase)
        else
          url_to_redirect=CGI.escape(user_location['city'].downcase)
        end
        redirect_to "/in/#{url_to_redirect}" and return
      rescue
        #the user location could not be not determined, send it to spain
        redirect_to "/in/spain" and return
      end
    end
    

    #first we check if this is a registered country
    result = conn.exec("SELECT * FROM geo_ips where lower(country_name)=$1 LIMIT 1",[CGI.unescape(params[:location]).downcase])
    
    
    if(result.first)
      #we have a country
      country_name=result.first["country_name"].downcase
      city_name=nil
    else
        result = conn.exec("SELECT * FROM geo_ips where lower(city)=$1 LIMIT 1",[CGI.unescape(params[:location]).downcase])
        if(result.first)
          #we have a city
          country_name=nil
          city_name=result.first["city"].downcase          
        else
          #we have nothing.
          redirect_to "/in/spain" and return
        end
    end        
    
    
    if !city_name.nil?      
      @city = City.find_or_create_by_name(city_name)
      
      # To show it in the title
      @actual_term_searched = @city.name
      
      sql="select distinct on (address,reported_date) *,
             (select count(id) from potholes where address=p.address)
             as counter from potholes as p where city_id = #{@city.id} 
             order by address, reported_date DESC"
      sqlCount="select count(*) as count from ("+sql+") as sql"
      @total_entries = (params[:total_entries]) ? 
      params[:total_entries].to_i : 
      Pothole.find_by_sql(sqlCount).first.count.to_i
              
      # Paginate
      @current_page = params[:page].blank? ? 1 : params[:page].to_i
      @potholes = WillPaginate::Collection.create(@current_page, 10, @total_entries) do |pager|
       
      potholes = Pothole.find_by_sql(sql +
        " limit #{pager.per_page} offset #{pager.offset}")
        pager.replace(potholes)
		  end

    elsif !country_name.nil?
      @country = Country.find_or_create_by_name(country_name)

      sql="select distinct on (address,reported_date) *,
        (select count(id) from potholes where address=p.address)
        as counter from potholes as p where country_id = #{@country.id} order by address, reported_date DESC"
      sqlCount="select count(*) as count from ("+sql+") as sql"
      @total_entries = (params[:total_entries]) ? params[:total_entries].to_i : Pothole.find_by_sql(sqlCount).first.count.to_i
      
      # Paginate
      @current_page = params[:page].blank? ? 1 : params[:page].to_i
      @potholes = WillPaginate::Collection.create(@current_page, 10, @total_entries) do |pager| 
        potholes = Pothole.find_by_sql(sql +" limit #{pager.per_page} offset #{pager.offset}")
        pager.replace(potholes)
      end
      
      @actual_term_searched = @country.name
      if (@actual_term_searched == "spain")
        @actual_term_searched = "España"
      end 
    else   
      #This should never happen. If happens send to 404                  
    end
    
    # Cities near
    @cities = City.all
    
    @city_name=city_name
    @country_name=country_name
    
    # Tell me all the cities with potholes
    @cities = City.find :all
    # @cities = City.find :all, :joins => [:potholes]
    
    @cities_and_count = Pothole.find_by_sql("select c.id, c.name, count(p.city_id) as counter 
      from cities c, potholes p where c.id=p.city_id GROUP BY c.id, c.name ORDER BY counter DESC limit 5")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @potholes }
    end
  end

  # GET /potholes/1
  # GET /potholes/1.xml
  def show 
            if !params.nil?
              @pothole = Pothole.find(params[:id])
                            
              respond_to do |format|
                format.html # show.html.erb
                format.xml  { render :xml => @pothole }
              end
              
            else
              render :xml => "{'Status':'Error'}"      
            end
        end

  # GET /potholes/new
  # GET /potholes/new.xml
  def new
    @pothole = Pothole.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pothole }
    end
  end

  # GET /potholes/1/edit
  def edit

    @pothole = Pothole.find(params[:id])
       
    @country =  Country.find_by_id(@pothole.country_id)
    @city = City.find_by_id(@pothole.city_id)
    
    respond_to do |format|
      if @pothole.update_attributes(:lat => @pothole.lat,
									:lon=> @pothole.lon,
									:reported_date => Time.now.strftime("%m/%d/%y %H:%M:%S"), 
									:reported_by => "web",
									:address => @pothole.address,
									:addressline => @pothole.addressline,
									:zip => @pothole.zip, 
									:city_id => @city.id,
									:country_id => @country.id)
        format.html { redirect_to :controller => "potholes", :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pothole.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /potholes
  # POST /potholes.xml
  def create
    
    @url = 'http://maps.google.com/maps/geo?q='+params[:lat]+','+params[:long]+'&output=json&sensor=true_or_false&key=83d63b531d7eb41fbaa916b1bc65ca9a';
   
    require 'open-uri'            
      open(@url) {
        |f| @result =  f.read
    }
    
    @result = JSON.parse(@result)
    
    # Comprobar si viene a nil alguno de los valores (google los puede devolver de aquella manera)
    @address = @result["Placemark"][0]["address"]
    @addressline = @result["Placemark"][0]["AddressDetails"]["Country"]["AdministrativeArea"]["SubAdministrativeArea"]["Locality"]["Thoroughfare"]["ThoroughfareName"]
    @city_name = @result["Placemark"][0]["AddressDetails"]["Country"]["AdministrativeArea"]["SubAdministrativeArea"]["Locality"]["LocalityName"]
    
    # Proabably nil
    @zip = @result["Placemark"][0]["AddressDetails"]["Country"]["AdministrativeArea"]["SubAdministrativeArea"]["Locality"]["PostalCode"]["PostalCodeNumber"]
    
    if @zip.nil? 
      @zip = "N/A" 
    end
    
    @country_name = @result["Placemark"][0]["AddressDetails"]["Country"]["CountryName"] # View the code (España/Spain)
    
    if ((@country_name == "España") || (@country_name == "Espanya"))
          @country_name = "spain"
    end  
    
    @country = Country.find_or_create_by_name(@country_name)
    @city = City.find_or_create_by_name(@city_name.downcase, :country_id => @country.id)
    
    # Data in correct format:
	  # LAT: 				40.43937044868159 		-> 40.43937
	  # LON: 				-3.7282773120117163 		-> -3.72822
	  # Reported_date: 09-02-2010					-> 08/30/10 13:42:59
	  # Address: Av de Juan de Herrera, 2, 28040 Madrid, Spain 
	  #				-> Calle de Marcelo Usera| 104| 28026 Madrid| Spain
	  # -----
	  lat = params[:lat][0..7]
	  long = params[:long][0..7]
	  @address = @address.gsub(",","|")
	  @addressline = @addressline.gsub(",","|") 
	  reported_date = Time.now.strftime("%m/%d/%y %H:%M:%S")
        
    # --------------
    # Fusion Tables
    ft = GData::Client::FusionTables.new
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")
    ft.clientlogin(config["google_username"], config["google_password"])
    # my_table = ft.show_tables[0]

	  #my_table.select COUNT() from "name", "WHERE x=n"
    # --------------

    print "\n\n\n ----- NUEVO_BACHE ------\n"
      
    # Add to Postgresql database
    @pothole = Pothole.new( :lat => lat,
                            :lon=> long,
                            :reported_date => reported_date,
                            :reported_by => "web",
                            :address => @address,
                            :addressline => @addressline,
                            :zip => @zip,
                            :city_id => @city.id,
                            :country_id => @country.id, 
                            :the_geom => Point.from_x_y(long,lat))

    # Fusion Tables
    sql = "insert into 272266 ('lat', 'lon', 'address', 'addressline',
                              'city', 'country', 'zip', 'reported_by', 'reported_date') 
                  values ('#{lat}', '#{long}', '#{@address}', '#{@addressline}', '#{@city.name}', 
                          '#{@country.name}', '#{@zip}', 'web', '#{reported_date}')"
    ft.sql_post(sql)
    # ---------------------
                 	   
    if @pothole.save
      render :text => "saved"
    else
      render :text => "failed"
    end   
  end

  # PUT /potholes/1
  # PUT /potholes/1.xml
  def update
    #debugger
    @pothole = Pothole.find(params[:id])

    respond_to do |format|
      if @pothole.update_attributes(params[:pothole])
        format.html { redirect_to(@pothole, :notice => 'Pothole was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pothole.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /potholes/1
  # DELETE /potholes/1.xml
  def destroy
    @pothole = Pothole.find(params[:id])
    @pothole.destroy

    respond_to do |format|
      format.html { redirect_to(potholes_url) }
      format.xml  { head :ok }
    end
  end
  
end
