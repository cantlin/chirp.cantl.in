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
    @user.send(params[:method], params[:user].split(' '))

    render 'edit'
  end

  def retry
    reset_session
    redirect_to new_session_path
  end

end
