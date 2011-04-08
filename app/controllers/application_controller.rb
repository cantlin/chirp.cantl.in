class ApplicationController < ActionController::Base  
  protect_from_forgery
  include SessionsHelper, RequestsHelper
  after_filter :update_last_login
end
