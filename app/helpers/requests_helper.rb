module RequestsHelper

  def oauth_consumer
    OAuth::Consumer.new(
      CONFIG['twitter_consumer_key'],
      CONFIG['twitter_consumer_secret'], {
        :site => CONFIG['twitter_request_uri'],
        :authorize_path => CONFIG['twitter_oauth_endpoint']
      }
    )
  end

  def access_token_from_request_token
    token_request = OAuth::RequestToken.new(oauth_consumer, session['request_token'], session['request_secret'])
    @access_token = token_request.get_access_token(:oauth_verifier => params[:oauth_verifier])
    reset_session
    return @access_token.token, @access_token.secret
  end

  def search_twitter_for(string)
    uri = URI.parse "#{CONFIG['twitter_search_uri']}#{CONFIG['twitter_method_paths']['search']}&q=#{URI.encode string}"
    response = Net::HTTP.get_response(uri)
    raise RequestError unless response.is_a? Net::HTTPSuccess
    (parse_body response)['results']
  end

  def parse_body(result)
    begin
      JSON.parse result.body
    rescue JSON::ParserError
      raise RequestError
    end
  end

  class RequestError < StandardError; end

  def render_request_error(exception)
    logger.warn exception
    render 'shared/request_error'
  end

end
