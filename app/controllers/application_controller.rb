class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  rescue_from Exception, :with => :render_500

  before_filter :prepare_for_mobile

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404: #{exception.message}"
      logger.info "Backtrace: #{exception.backtrace}"
    end

    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500: #{exception.message}"
      logger.info 'Backtrace:'
      logger.info exception.backtrace.join("\n")
    end

    render :file => "#{Rails.root}/public/500.html", :status => 500, :layout => false
  end


  private

  def mobile_device?
    return (request.user_agent =~ /Mobile|Opera Mobi|webOS/)
  end

  def prepare_for_mobile
    #request.format = :mobile if mobile_device?
    request.format = :mobile
  end

end
