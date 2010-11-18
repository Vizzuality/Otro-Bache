class Pothole < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  mount_uploader :photo, PhotoUploader

  attr_accessor :count

  validates_presence_of :lat, :lon, :address, :zip
  validates_exclusion_of :address, :in => %w(null), :message => "Address must be given."
  validates_exclusion_of :zip, :in => %w(null), :message => "Zip must be given."

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
    distance_of_time_in_words(reported_date, Time.now) unless reported_date.blank?
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
    ft.clientlogin(APP_CONFIG[:google_username], APP_CONFIG[:google_password])

    sql = "insert into #{APP_CONFIG[:fusion_tables_id]} ('lat', 'lon', 'address', 'addressline',
                              'city', 'country','country_code', 'zip', 'reported_by', 'reported_date', 'pothole_id')
                  values ('#{lat}', '#{lon}', #{encode_text(address)}, #{encode_text(addressline)},
                          #{encode_text(city.name)},
                          #{encode_text(country.name)},#{encode_text(country.code)}, #{encode_text(zip)},
                          'web', '#{reported_date}', #{to_param})"
    ft.sql_post(sql)

    #File.open("#{Rails.root}/public/data.csv", 'a') {|f|
    #  f.puts("#{lat},#{lon},#{encode_text(address)},#{encode_text(addressline)},#{encode_text(city.name)},#{encode_text(country.name)},#{encode_text(zip)},web,#{reported_date},#{encode_text(country.code)},#{to_param}")
    #}
    #lat,lon,address,addressline,city,country,zip,reported_by,reported_date,country_code,pothole_id

  end
end
