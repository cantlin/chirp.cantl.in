class ApplicationController < ActionController::Base
  
  protect_from_forgery

  def oauth_consumer
    OAuth::Consumer.new(CONFIG['global']['twitter_consumer_key'], CONFIG['global']['twitter_consumer_secret'],
      :site => CONFIG['global']['twitter_api_uri'],
      :request_endpoint => CONFIG['global']['twitter_oauth_endpoint_uri'],
      :sign_in => true
    )
  end
  
end
