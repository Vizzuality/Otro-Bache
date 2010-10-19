class AboutController < ApplicationController
  def index
    @country_name = session[:country]
  end
end
