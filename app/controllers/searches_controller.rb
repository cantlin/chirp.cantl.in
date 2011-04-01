class SearchesController < ApplicationController
  before_filter :authenticate

  def new
    current_user
    @search = Search.new(:query => params[:query])
    @results = @search.results
  end

end
