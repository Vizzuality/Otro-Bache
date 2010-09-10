class City < ActiveRecord::Base
  has_geom :the_geom => :point
  belongs_to :country
  has_many :potholes
end
