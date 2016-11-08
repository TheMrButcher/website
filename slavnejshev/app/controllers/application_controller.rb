class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def default_url_options
    if I18n.locale == I18n.default_locale
      {}
    else
      { locale: I18n.locale }
    end
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
