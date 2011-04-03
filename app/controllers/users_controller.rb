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
    current_user
    @user = (params[:id]) ? User.find_by_id(params[:id]) : @current_user

    @twitter_users = @user.following
  end

  def follow
    @user = User.find_by_id(params[:id])

    prefix = 'user_' # So we don't end up trying to follow "authenticity_token"

    @followed_users = []
    params.each do |key, value|
      if key.include? prefix
        @followed_users.push(key.gsub prefix, '') unless @user.following.include? key
      end
    end

#    @user.follow(@followed_users) unless @followed_users.blank?

    @twitter_users = @user.following
    render 'edit'
  end

  def unfollow
    @user = User.find_by_id(params[:id])

    prefix = 'user_' # So we don't end up trying to unfollow "authenticity_token"

    @unfollowed_users = []
    @user.following.each do |hash|
      @unfollowed_users.push hash[:screen_name] unless params.include? prefix + hash[:screen_name]
    end

#    @user.unfollow(@unfollowed_users) unless @unfollowed_users.blank?

    @twitter_users = @user.following
    render 'edit'
  end

  def foo
    str = 'ianbrechin, ellielotan, pmateus19, bryonybuttercup, IceFrog, revfitz, yyler, richardashrowan, beatentracks, sneakytiptoes, RazLDazzle, tealsocks, MackJ, MilesGrover, stephenfry, DeuceAtJerkcity, perfectstars, DickAtJerkcity, PantsAtJerkcity, EffigyJerkcity, nnnkneesknees, jerkcity, SpigotTheBear, birdlord, flappitybat, Jeff_Thomson, cganders, eigenharp, eigenlabs, zacharyforever, shitmydadsays, noisycrow, samuelh, hattiepaw, pigeonheart, karlfun, leisuretown, F_RED, tamminhnguyen, twibbermonkey, rpenguin, westacular, shana_banana, malki, cramchowder, david_ammann, EdinburghBooks, ponkbonk, black_medicine, FalkoBakery, emmy_the_great, katenash, HackerNewsTips'

    array = str.split(', ')

    array.each {|a| current_user.follow a}
  end

  private

  def authorize
    if(params[:id])
      @user = User.find_by_id(params[:id])    
      redirect_to root_url unless (@user && @user[:id] == @current_user[:id])
    end
  end

  def retry
    reset_session
    redirect_to new_session_path
  end

end
