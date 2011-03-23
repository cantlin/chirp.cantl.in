class ApplicationController < ActionController::Base  
  before_filter :set_locale
  protect_from_forgery

  def oauth_consumer
    # http://oauth.rubyforge.org/rdoc/classes/OAuth/Consumer.html
    OAuth::Consumer.new(CONFIG['twitter_consumer_key'], CONFIG['twitter_consumer_secret'], {
      :site => CONFIG['twitter_api_uri'],
      :request_endpoint => CONFIG['twitter_oauth_endpoint_uri'],
      :sign_in => true
    })
  end
  
  def set_locale
    I18n.locale = params[:locale]
  end

end
