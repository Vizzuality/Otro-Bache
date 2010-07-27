class PotholesController < ApplicationController
  # GET /potholes
  # GET /potholes.xml
  def index
    @potholes = Pothole.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @potholes }
    end
  end

  # GET /potholes/1
  # GET /potholes/1.xml
  def show  
    
    @pothole = Pothole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pothole }
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
  end

  # POST /potholes
  # POST /potholes.xml
  def create
    print "\n\n\n ----- create_ini ------\n"
    debugger
    
    @country =  Country.find_or_create_by_name(params[:pothole][:country])
    @city = City.find_or_create_by_name(params[:pothole][:city], :country_id => @country.id)
    
    if (Pothole.find(:first, :conditions => ["lat = ? AND lon = ?", params[:pothole][:lat], params[:pothole][:lon]]) == nil)
      print "\n\n\n ----- NUEVO_BACHE ------\n"
      @pothole = Pothole.new( :lat => params[:pothole][:lat],
                              :lon=> params[:pothole][:lon],
                              :reported_date => Time.now,
                              :reported_by => "web",
                              :address => params[:pothole][:address],
                              :zip => params[:pothole][:zip],
                              :counter => 1,
                              :city_id => @city.id,
                              :country_id => @country.id)

      respond_to do |format|
        if @pothole.save
          format.html { redirect_to(@pothole, :notice => 'Pothole was successfully created.') }
          format.xml  { render :xml => @pothole, :status => :created, :location => @pothole }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @pothole.errors, :status => :unprocessable_entity }
        end
      end
      
    else
      print "\n\n\n ----- ACTUALIZO_BACHE ------\n"
      @count = Pothole.find(:first, :conditions => ["lat = ? AND lon = ?", params[:pothole][:lat], params[:pothole][:lon]]).counter + 1
      params[:pothole][:reported_date] = Time.now
      params[:pothole][:counter] = @count
      debugger
#      @pothole = Pothole.find(:first, :conditions => ["lat = ? AND lon = ?", params[:pothole][:lat], params[:pothole][:lon]])
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
    
    print "\n\n\n ----- create_pothole_creado ------"    
    
  end

  # PUT /potholes/1
  # PUT /potholes/1.xml
  def update
    debugger
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
