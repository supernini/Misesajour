class ApplicationController < ActionController::Base
  before_filter :set_lang
  protect_from_forgery

  def set_lang
    if request.subdomains.first=='en'
      I18n.locale = 'en'
    else
      I18n.locale = 'fr'
    end
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def rescue_404
    redirect_to '/', :status => 301
  end

  def rescue_with_handler(exception)
    #redirect_to '/', :status => 301
  end

  def method_missing(id, *args)
    #redirect_to '/', :status => 301
  end
end
