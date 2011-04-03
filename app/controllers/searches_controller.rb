class SearchesController < ApplicationController
  before_filter :authenticate

  def new
    @user = current_user
    @search = Search.new(:query => params[:query])
    @twitter_users = @search.results
  end

end
