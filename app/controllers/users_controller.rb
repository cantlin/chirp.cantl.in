class UsersController < ApplicationController
  rescue_from OAuth::Unauthorized, :with => :retry
  before_filter :authenticate

  def show
    current_user.save unless !signed_in?
  end

  def new
    token_request = OAuth::RequestToken.new(oauth_consumer, session['request_token'], session['request_secret'])
    reset_session
    access_token = token_request.get_access_token(:oauth_verifier => params[:oauth_verifier])
    @user = User.from_token(access_token.token, access_token.secret)
    @user ||= User.new(:access_token => access_token.token, :access_token_secret => access_token.secret)
    (@user.verify && @user.save) ? sign_in(@user) : render('shared/error')
  end

  def update
    if(params[:users] && params[:method])
      @users_acted_on = []
      params[:users].split(' ').each {|screen_name| @users_acted_on.push screen_name unless screen_name.empty?}
      current_user.send(params[:method], @users_acted_on)
    end
    render 'show'
  end

  def retry
    reset_session
    redirect_to new_session_path
  end

end
