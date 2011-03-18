require 'spec_helper'

describe SessionsController do
  
  describe "GET 'new'" do
    it "should redirect" do
      get 'new'
      response.should be_redirect
      # Be nice if we could check that we got the page we were expecting..?
    end
  end # GET new

end
