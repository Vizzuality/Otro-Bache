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
#     @pothole = Pothole.new(params[:pothole])
	print "pon algo"
	STDIN.read
	print "por aqui"
#     respond_to do |format|
#       if @pothole.save
#         format.html { redirect_to(@pothole, :notice => 'Pothole was successfully created.') }
#         format.xml  { render :xml => @pothole, :status => :created, :location => @pothole }
#       else
#         format.html { render :action => "new" }
#         format.xml  { render :xml => @pothole.errors, :status => :unprocessable_entity }
#       end
#     end
  end

  # PUT /potholes/1
  # PUT /potholes/1.xml
  def update
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
