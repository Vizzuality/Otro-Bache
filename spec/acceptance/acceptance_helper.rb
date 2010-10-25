require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'

Capybara.default_driver    = :selenium
Capybara.default_selector  = :css
Capybara.default_wait_time = 30

Rspec.configure do |config|
  config.include Capybara
  config.include ActiveSupport::Testing::Assertions

  config.global_fixtures = :geo_ips

  config.before(:each) do
    Capybara.use_default_driver
    Capybara.reset_sessions!
    Rails.cache.clear
  end
end

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
