class ApplicationController < ActionController::Base  
  protect_from_forgery
  before_filter :set_locale
  include SessionsHelper

  def set_locale
    I18n.locale = params[:locale]
  end

end
