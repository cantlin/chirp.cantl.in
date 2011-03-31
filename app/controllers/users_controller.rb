class UsersController < ApplicationController
  before_filter :authenticate, :except => :new
  rescue_from OAuth::Unauthorized, :with => :retry

  def new
    token, secret = access_token_from_request_token

    @user = User.from_token(token, secret)
    @user ||= User.new(:access_token => token, :access_token_secret => secret)

    (@user.verify && @user.save) ? sign_in(@user) : render('shared/error')
  end
  
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    @users_acted_on = []
    params[:users].split(' ').each {|screen_name| @users_acted_on.push screen_name unless screen_name.empty?}
    @user.send(params[:method], @users_acted_on)

    render 'edit'
  end

  def retry
    reset_session
    redirect_to new_session_path
  end

end
