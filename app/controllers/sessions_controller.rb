class SessionsController < ApplicationController

  def new
  end

  def create
    sign_out if signed_in?
    request_token = oauth_consumer.get_request_token(:oauth_callback => CONFIG[Rails.env]['twitter_callback_uri'])
    session['request_token'] = request_token.token
    session['request_secret'] = request_token.secret
    redirect_to request_token.authorize_url
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
