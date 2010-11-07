class Pothole < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  mount_uploader :photo, PhotoUploader

  attr_accessor :count

  validates :lat, :presence => true
  validates :lon, :presence => true
  validates :address, :presence => true
  validates :zip, :presence => true

  belongs_to :city
  belongs_to :country

  after_create :add_to_fusion_tables

  has_geom :the_geom => :point

  def photo_url
    photo.url
  end

  def thumb_url
    photo && photo.thumb ? photo.thumb.url : nil
  end

  def last_time
    distance_of_time_in_words(updated_at, Time.now) unless reported_date.blank?
  end

  def to_json
    attributes = {
      :include => [:city],
      :except => [:photo],
      :methods => [:photo_url, :thumb_url, :count, :last_time]
    }
    super(attributes)
  end

  def add_to_fusion_tables
    ft = GData::Client::FusionTables.new
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")
    ft.clientlogin(config["google_username"], config["google_password"])

    sql = "insert into 272266 ('lat', 'lon', 'address', 'addressline',
                              'city', 'country','country_code', 'zip', 'reported_by', 'reported_date', 'pothole_id')
                  values ('#{lat}', '#{lon}', #{encode_text(address)}, #{encode_text(addressline)},
                          #{encode_text(city.name)},
                          #{encode_text(country.name)},#{encode_text(country.code)}, #{encode_text(zip)},
                          'web', '#{reported_date}', #{to_param})"
    ft.sql_post(sql)
  end
end
