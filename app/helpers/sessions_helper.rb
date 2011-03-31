module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
  end

  def sign_out
    cookies.delete :remember_token
    cookies.delete :dismissed
    reset_session
  end

  def signed_in?
    !cookies.signed[:remember_token].blank?
  end

  def current_user
    @current_user ||= User.from_cookie(*cookies.signed[:remember_token]) if cookies.signed[:remember_token]
  end

  def authenticate
    @current_user = current_user
    redirect_to login_path unless (@current_user && @current_user.save)
  end

  def oauth_consumer
    OAuth::Consumer.new(
      CONFIG['twitter_consumer_key'],
      CONFIG['twitter_consumer_secret'], {
        :site => CONFIG['twitter_request_uri'],
        :authorize_path => CONFIG['twitter_oauth_endpoint']
      }
    )
  end

  def access_token_from_request_token
    token_request = OAuth::RequestToken.new(oauth_consumer, session['request_token'], session['request_secret'])
    access_token = token_request.get_access_token(:oauth_verifier => params[:oauth_verifier])
    reset_session
    return access_token.token, access_token.secret
  end

end
