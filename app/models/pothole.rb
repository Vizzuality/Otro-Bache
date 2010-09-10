class Pothole < ActiveRecord::Base
  validates :lat, :presence => true
  validates :lon, :presence => true
  validates :address, :presence => true
  validates :zip, :presence => true  
  belongs_to :city
  belongs_to :country
  has_geom :the_geom => :point
  
end
