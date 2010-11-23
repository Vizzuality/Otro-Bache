# encoding: utf-8
class Api::ApiController < ApplicationController

  def get_near_localities
    result=Array.new
    sql=""
    if (!params[:current_city_id].nil? and params[:current_city_id]!="")
      sql="and id<>#{params[:current_city_id]}"
    end
    result = City.find_by_sql("select id,name,  
    							ST_Distance(the_geom::geography, 
    							makepoint(#{params[:lon]},#{params[:lat]})::geography) as dis, 
    							(select count(id) from potholes where city_id=c.id) as num_baches 
								from cities as c 
								WHERE (select count(id) from potholes where city_id=c.id)>0
								#{sql}
								order by dis ASC
								limit 5")
								
	  res= Array.new
		result.each do |city|
		  res << {:name=>city.name,:id=>city.id,:num_baches=>city.num_baches}
	  end
		
	 respond_to do |format|
    	format.json do 
        render :json => res.to_json
      end
    end
  end
  
end	