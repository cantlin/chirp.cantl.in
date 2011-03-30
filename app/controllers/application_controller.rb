class ApplicationController < ActionController::Base  
  protect_from_forgery
  before_filter :set_locale
  helper_method :current_user
  include SessionsHelper

  def set_locale
    I18n.locale = params[:locale]
  end

  private

  def current_user
    @current_user ||= User.from_cookie(*cookies.signed[:remember_token]) if cookies.signed[:remember_token]
  end

  def twitter_is_down
    render 'twitter is down'
  end

end
