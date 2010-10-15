class CitiesController < ApplicationController
  def index
    
    @country_name = session[:country]
    
    #select all countries
    sql="select c.id,c.name,count(p.id) as num_baches from potholes as p inner join countries as c on p.country_id=c.id
    group by c.id,c.name
    order by num_baches DESC, c.name"
    countries = ActiveRecord::Base.connection.execute(sql)
    @result = Array.new();
    countries.each do | c |
      #for each country
      sql="select c.name,count(p.id) as num_baches from potholes as p inner join cities as c on p.city_id=c.id
      where p.country_id=#{c["id"]}
      group by c.name
      order by num_baches DESC, c.name"
      cities = ActiveRecord::Base.connection.execute(sql).map do |city|
        {:name=>city["name"],:num_baches=>city["num_baches"]}
      end 
      @result<<{:name=>c["name"],:num_baches=>c["num_baches"],:cities=>cities}
    end
    
    
  end
end
