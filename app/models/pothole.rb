class Pothole < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  validates :lat, :presence => true
  validates :lon, :presence => true
  validates :address, :presence => true
  validates :zip, :presence => true

  belongs_to :city
  belongs_to :country

  has_geom :the_geom => :point

  def photo_url
    photo.url
  end

  def thumb_url
    photo && photo.thumb ? photo.thumb.url : nil
  end

  def to_json
    attributes = {
      :except => [:photo],
      :methods => [:photo_url, :thumb_url]
    }
    super(attributes)
  end

end
