class GeoIp < ActiveRecord::Base
  scope :where_ip, lambda { |ip| scoped.where("ip_start <= inetmi(?,'0.0.0.0')", ip).order('ip_start DESC') }
  scope :where_country, lambda { |country_name| scoped.where('lower(country_name) = ?', CGI.unescape(country_name).downcase) }
  scope :where_city, lambda { |city_name| scoped.where('lower(city) = ?', CGI.unescape(city_name).downcase) }
end