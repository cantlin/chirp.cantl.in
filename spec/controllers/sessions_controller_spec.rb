require 'spec_helper'

describe SessionsController do
  
  describe "GET 'new'" do
    it "should redirect" do
      get 'new'
      response.should be_redirect
      # Be nice if we could check that we got the page we were expecting..?
    end
  end # GET new

  describe "GET 'callback'" do
    it 'should error without params' do
      get 'callback'
      response.should render_template('shared/error')
    end
    it 'should error with invalid params' do
      get 'callback', {:oauth_verifier => '1', :oauth_token => '1'}
      response.should render_template('shared/error')
    end
  end # GET callback

end
