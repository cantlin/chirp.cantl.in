class SessionsController < ApplicationController
  rescue_from OAuth::Unauthorized, :with => :try_again
  
  def new
    request_token = oauth_consumer.get_request_token(:oauth_callback => CONFIG[Rails.env]['twitter_callback_uri'])
    session['request_token'] = request_token.token
    session['request_secret'] = request_token.secret
    redirect_to request_token.authorize_url
  end
  
  def callback
    # Swap our request token/secret for an access token/secret
    token_request = OAuth::RequestToken.new(oauth_consumer, session['request_token'], session['request_secret'])
    access_token = token_request.get_access_token(:oauth_verifier => params[:oauth_verifier])

    # Make sure that worked
    if access_token.nil?
      flash.now[:error] = t(:error_unexpected)
      render 'shared/error' and return
    end

    # Clear the request tokens from the session
    reset_session

    # Make sure our new tokens are good
    verify_credentials = access_token.get('/1/account/verify_credentials.json')
    twitter_user_data = JSON.parse(verify_credentials.body)
    if twitter_user_data['screen_name'].nil?
      flash.now[:error] = t(:error_bad_token)
      render 'shared/error' and return
    end

    # Store them
    @user = User.new(:access_token => access_token.token, :access_token_secret => access_token.secret)
    if @user.save
      flash[:success] = t(:user_signed_in)
      # Set a secure cookie
      cookies.permanent.signed[:remember_token] = [@user.id, @user.salt]
      # Store some inconsequential data in the session for convenience
      session['screen_name'] = twitter_user_data['screen_name']
      session['profile_background_image_url'] = twitter_user_data['profile_background_image_url']
    else
      render 'shared/error'
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
  
  def try_again
    reset_session
    redirect_to new_session_path
  end

end
