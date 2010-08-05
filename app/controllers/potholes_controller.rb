# encoding: utf-8
class PotholesController < ApplicationController
  
  # define('FLICKR_API_KEY', '83d63b531d7eb41fbaa916b1bc65ca9a');
  # define('FLICKR_API_SECRET', 'e4dac314a1e456af');
  
  
  # GET /potholes
  # GET /potholes.xml
  def index
            
    if !params[:city].nil?      
      @city = City.find_by_name(params[:city])
      @potholes = Pothole.find(:all, :conditions => ["city_id = ?", @city.id])   
      
      # To show it in the title
      @actual_term_searched = @city.name
      
      # How many potholes we have in the city that we are showing
      @potholes_size_actual = @potholes.size
    else
        if !params[:id].nil?
            potholes = []
            potholes << Pothole.find(params[:id])
            @potholes = potholes
        else
            if !params[:country].nil?
              @country = Country.find_by_name(params[:country])
              @potholes = Pothole.find(:all, :conditions => ["country_id = ?", @country.id])
              
              # How many potholes we have in the city that we are showing
              @potholes_size_actual = @potholes.size
              @actual_term_searched = @country.name
              if (@actual_term_searched == "spain")
                @actual_term_searched = "España"
              end 
            else              
              @potholes = Pothole.all
              @potholes_size_actual = @potholes.size
              @actual_term_searched = "total"
            end
        end
    end
    
    # Cities near
    @cities = City.all
    
    # Tell me all the cities with potholes
    @cities = City.find :all
    # @cities = City.find :all, :joins => [:potholes]
    
    
    # I want to create a new array with the data of the city and the number of potholes that there are
    @cities_and_count = []
    
    @cities.each do |city|
      @counter = Pothole.count(:conditions => ["city_id = ?", city.id])         
      @cities_and_count << {:city => city, :counter => @counter} 
    end

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
    
    @count = @pothole.counter + 1
    
    @country =  Country.find_by_id(@pothole.country_id)
    @city = City.find_by_id(@pothole.city_id)
    
    respond_to do |format|
      if @pothole.update_attributes(:lat => @pothole.lat,
									:lon=> @pothole.lon,
									:reported_date => Time.now, 
									:reported_by => "web",
									:address => @pothole.address,
									:zip => @pothole.zip,
									:counter => @count, 
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
    
    @country =  Country.find_or_create_by_name(@country_name)
    @city = City.find_or_create_by_name(@city_name, :country_id => @country.id)
    

    # $addressline="";
    # $addressline= $jsondata['Placemark'][0]['AddressDetails']['Country']['AdministrativeArea']['SubAdministrativeArea']['Locality']['AddressLine'][0];
    # 
    # if($addressline=="") {
    #     $addressline= $jsondata['Placemark'][0]['AddressDetails']['Country']['AdministrativeArea']['SubAdministrativeArea']['Locality']['Thoroughfare']['ThoroughfareName'];
    # }
    # if($addressline=="") {
    #     $addressline= $jsondata['Placemark'][0]['AddressDetails']['Country']['AdministrativeArea']['SubAdministrativeArea']['Locality']['DependentLocality']['DependentLocalityName'];
    # }        
    # $addressline=str_replace(",","|",$addressline);
    
    if (Pothole.find(:first, :conditions => ["lat = ? AND lon = ?", params[:lat], params[:long]]) == nil)
      print "\n\n\n ----- NUEVO_BACHE ------\n"
      @pothole = Pothole.new( :lat => params[:lat],
                              :lon=> params[:long],
                              :reported_date => Time.now,
                              :reported_by => "web",
                              :address => @address,
                              :zip => @zip,
                              :counter => 1,
                              :city_id => @city.id,
                              :country_id => @country.id)

      respond_to do |format|
        if @pothole.save
          format.html { redirect_to :controller => "potholes", :action => "index" }
          # format.xml  { head :ok }
          format.xml  { render :xml => @pothole, :status => :created, :location => @pothole }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @pothole.errors, :status => :unprocessable_entity }
        end
      end
      
    else
      print "\n\n\n ----- ACTUALIZO_BACHE ------\n"
      @pothole = Pothole.find(:first, :conditions => ["lat = ? AND lon = ?", params[:pothole][:lat], params[:pothole][:lon]])
	  
      @count = @pothole.counter + 1

      respond_to do |format|
        if @pothole.update_attributes(	:lat => params[:pothole][:lat],
										:lon=> params[:pothole][:lon],
										:reported_date => Time.now, 
										:reported_by => "web",
										:address => params[:pothole][:address],
										:zip => params[:pothole][:zip],
										:counter => @count, 
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
    
    print "\n\n\n ----- create_pothole_creado ------"    
    
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
