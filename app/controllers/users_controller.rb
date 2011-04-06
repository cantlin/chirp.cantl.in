class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new]
  before_filter :authorize, :except => [:new, :show]
  rescue_from OAuth::Unauthorized, :with => :retry

  def new
    token, secret = access_token_from_request_token

    @user = User.from_token(token, secret)
    @user ||= User.new(:access_token => token, :access_token_secret => secret)

    (@user.verify && @user.save) ? sign_in(@user) : render('shared/error')
  end
  
  def edit
    @user = (params[:id]) ? User.find_by_id(params[:id]) : current_user

    @twitter_users = @user.following
  end

  def update
    @user = User.find_by_id params[:id]

    params[:follow].each {|name| @user.follow name} if params[:follow]
    params[:unfollow].each {|name| @user.unfollow name} if params[:unfollow]

    @twitter_users = @user.following
    render 'edit'
  end

  private

  def authorize
    if params[:id]
      @user = User.find_by_id params[:id]
      redirect_to root_url unless (@user && @user[:id] == @current_user[:id])
    end
  end

  def retry
    reset_session
    redirect_to new_session_path
  end

end
