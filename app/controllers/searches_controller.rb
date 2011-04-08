class SearchesController < ApplicationController
  before_filter :authenticate
  rescue_from RequestsHelper::RequestError, :with => :render_request_error

  def new
    @user = current_user

    @search = Search.new(:query => params[:query])

    @twitter_users = @search.results(@user)
  end

end
