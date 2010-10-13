# encoding: utf-8
class PotholesController < ApplicationController

  # define('FLICKR_API_KEY', '83d63b531d7eb41fbaa916b1bc65ca9a');
  # define('FLICKR_API_SECRET', 'e4dac314a1e456af');


  # GET /potholes
  # GET /potholes.xml
  def index
    #If the controller is called without location params we redirect where the user is geolocating its IP
    if params[:location].blank?
      #geolocate
      begin
        url_to_redirect = "spain"
        user_location = LatLong.where_ip(request.env[:REMOTE_ADDR]).first
        if user_location.city.blank? && user_location.country_name.present? && user_location.country_name == "Reserved"
          url_to_redirect = "spain"
        elsif user_location.city.blank?
          url_to_redirect = CGI.escape(user_location.country_name.downcase)
        else
          url_to_redirect = CGI.escape(user_location.city.downcase)
        end
        redirect_to "/in/#{url_to_redirect}" and return
      rescue
        #the user location could not be not determined, send it to spain
        redirect_to "/in/spain" and return
      end
    end

    #first we check if this is a registered country
    result = LatLong.where_country(params[:location]).first

    if result
      #we have a country
      country_name = result.country_name.downcase
      country_code = result.country_code
      city_name    = nil
    else
        result = LatLong.where_city(params[:location]).first
        if(result)
          #we have a city
          country_name = nil
          city_name    = result.city.downcase
        else
          #we have nothing.
          redirect_to "/in/spain" and return
        end
    end

    if city_name.present?
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

    elsif country_name.present?
      @country = Country.find_or_create_by_code(country_code, :name=>country_name)

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

    @countries = Country.all
    
    @city_name=city_name
    @country_name=country_name
    session[:country] = @country.name

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
  
      sql="select distinct on (address,reported_date) *,
             (select count(id) from potholes where address=p.address)
             as counter from potholes as p where lat = #{@pothole.lat} and lon = #{@pothole.lon} 
             order by address, reported_date DESC"
      sqlCount="select count(*) as count from ("+sql+") as sql"

      @counter = Pothole.find_by_sql(sqlCount).first.count.to_i
                                
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

    res           = Geokit::Geocoders::GoogleGeocoder.reverse_geocode(params[:lat]+','+params[:long])
    @country_name = res.country
    @country_code = res.country_code
    @address      = res.full_address
    @addressline  = res.street_address
    @city_name    = res.city
    @zip          = res.zip

    #find our country and city
    begin
      conn          = PGconn.connect( :dbname => 'ipinfo', :user => 'postgres' )
      result        = conn.exec("SELECT * FROM geo_ips where country_code=$1 LIMIT 1",[@country_code])
      @country_name = result.first["country_name"].downcase
    rescue
    end



    if @zip.blank?
      @zip = "N/A"
    end

    @country = Country.find_or_create_by_code(@country_code, :name=>@country_name)
    @city = City.find_or_create_by_name(@city_name.downcase, :country_id => @country.id)

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
                              'city', 'country','country_code', 'zip', 'reported_by', 'reported_date')
                  values ('#{lat}', '#{long}', #{encode_text(@address)}, #{encode_text(@addressline)},
                          #{encode_text(@city.name)},
                          #{encode_text(@country.name)},#{encode_text(@country.code)}, #{encode_text(@zip)},
                          'web', '#{reported_date}')"
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

def encode_text data
  return "'#{data.gsub(/\\/, '\&\&').gsub(/'/, "''")}'"
end
def encode_date data
  return "'#{data.strftime("%m-%d-%Y %H:%M:%S")}'"
end
