class SearchesController < ApplicationController
  before_filter :authenticate

  def new
    @search = Search.new(:query => params[:query])
    @users = @search.results
  end

end
