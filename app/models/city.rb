class City < ActiveRecord::Base
  has_geom :the_geom => :point
  belongs_to :country
  has_many :potholes

  after_create :save_point
  
  private
  
    def save_point
      geo = Google::Geo.new "83d63b531d7eb41fbaa916b1bc65ca9a"
      address = geo.locate self.name
		lon = address[0].coordinates[0]
		lat = address[0].coordinates[1]
		self.the_geom = Point.from_x_y(lon,lat)
    end
      
end
