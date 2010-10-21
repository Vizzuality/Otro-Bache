source 'http://rubygems.org'

gem 'rails', '3.0.0'

gem 'pg'
gem 'ppe-postgis-adapter', :git => 'git://github.com/ferblape/postgis_adapter.git', :require => 'postgis_adapter'

gem 'nofxx-georuby', :require => 'geo_ruby'

gem 'gdata_19'
gem 'geokit'
gem 'geokit-rails', :git => 'git://github.com/jlecour/geokit-rails.git', :branch => 'gem' 

gem 'fusion_tables', '0.2.2'

gem 'google-geo', :require =>'google/geo'
gem "will_paginate", "~> 3.0.pre2"

gem 'json'

gem 'hoptoad_notifier'

gem 'capistrano'
gem 'capistrano-ext'

gem 'carrierwave'

# Development
group :development, :test do
  if RUBY_VERSION < '1.9'
    gem 'ruby-debug'
  else
    gem 'ruby-debug19'
  end
end

group :test do
  gem 'rspec-rails'
end