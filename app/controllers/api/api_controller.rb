# encoding: utf-8
class Api::ApiController < ApplicationController

  def get_near_localities
    
    result = City.find_by_sql("select id,name,  
    							ST_Distance(the_geom::geography, 
    							makepoint(#{params[:lon]},#{params[:lat]})::geography) as dis, 
    							(select count(id) from potholes where city_id=c.id) as num_baches 
								from cities as c 
								order by dis ASC
								limit 5")

	 respond_to do |format|
    	format.json do 
        render :json => result.to_json
      end
    end
  end
  
end	