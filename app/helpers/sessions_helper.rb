module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
  end

  def sign_out
    cookies.delete :remember_token
  end

  def signed_in?
    !cookies.signed[:remember_token].blank?
  end

  def authenticate
    current_user
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

end
