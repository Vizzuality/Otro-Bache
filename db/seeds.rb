Dir["#{Rails.root}/db/seeds/**/*.rb"].each {|f| require f}
