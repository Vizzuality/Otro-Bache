module ApplicationHelper
  def country_or_city?(country, city)
    if country || city
      "(#{country ? country.upcase : city.upcase})"
    end
  end
end
