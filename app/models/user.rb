class User < ActiveRecord::Base
  include SessionsHelper
  attr_accessible
#  rescue_from JSON::ParseError, :with => :something

  validates :access_token,
    :presence => true,
    :uniqueness => true,
    :length => {:minimum => 32, :maximum => 64}
  validates :access_token_secret,
    :presence => true,
    :uniqueness => true,
    :length => {:minimum => 32, :maximum => 64}

  before_save :set_salt, :set_last_login

  def set_salt
    self.salt = BCrypt::Engine.generate_salt if new_record?
  end

  def set_last_login
    self.last_login = Time.now.utc
  end

  def followed_by
    twitter_authenticated_request_parsed 'get_followed_by'
  end

  def followed_by=(value)
    self.followed_by = value
  end

  def following(cursor = -1)
    Rails.cache.fetch("following/#{id}", :expires_in => 1.hour) do
        result = twitter_request_authenticated('get_following', {:cursor => cursor})
        parse_body(result)['users'].map do |user|              
          { :twitter_id => user['id'],
            :screen_name => user['screen_name'],
            :name => user['name'],
            :image => user['profile_image_url'],
            :location => user['location'],
            :status => user['status'] ? user['status']['text'] : nil }
      end
    end
  end

  def following(cursor = -1)
    Rails.cache.fetch("following/#{id}", :expires_in => 1.hour) do
      result = twitter_request_authenticated('get_following', {:cursor => cursor})
      followed_users = parse_body(result)['users']
      twitter_user_list = []
      followed_users.each do |user|
#       this_user = TwitterUser.new(:twitter_id => user['id'], :screen_name => user['screen_name'], :name => user['name'], :image => user['profile_image_url'], :location => user['location'])
        this_user = {'twitter_id' => user['id'], 'screen_name' => user['screen_name'], 'name' => user['name'], 'image' => user['profile_image_url'], 'location' => user['location']}
        this_user['status'] = user['status']['text'] unless user['status'].nil?
        twitter_user_list.push this_user
      end
      twitter_user_list
    end
  end

  def following=(value)
    self.following = value
  end

  def unfollow(screen_name)
    if(screen_name.is_a? Array)
      screen_name.each {|u| unfollow u }
    else
      twitter_request_authenticated('unfollow', {:screen_name => screen_name}, 'post')
    end
    Rails.cache.delete("following/#{id}")
  end

  def follow(screen_name)
    if(screen_name.is_a? Array)
      screen_name.each {|u| follow u }
    else
      twitter_request_authenticated('follow', {:screen_name => screen_name}, 'post')
    end
    Rails.cache.delete("following/#{id}")
  end

  def verify
    result = twitter_authenticated_request_parsed('verify_credentials')
    (result && result['screen_name']) ? self.screen_name = result['screen_name'] : nil
  end

  class << self

    def from_cookie(id, salt)
      user = find_by_id(id)
      (user && user.salt == salt) ? user : nil
    end

    def from_token(token, secret)
      find_by_access_token_and_access_token_secret(token, secret)
    end

  end

  private

  def twitter_request_authenticated(method_key, params = {}, method = 'get')
    access_token = OAuth::AccessToken.new(oauth_consumer, self.access_token, self.access_token_secret)
    method_path = CONFIG['twitter_method_paths'][method_key] # See /config/app_config.yml
    if(!params.empty?)
      method_path += '?'
      params.each do |parameter, value|
        method_path += "#{parameter}=#{value}&"
      end
      method_path.chop!
    end
    access_token.send(method, method_path)
  end

  def parse_body(result)
    begin
      JSON.parse(result.body)
    rescue Exception => e
      raise 'Twitter is down!' and return
    end
  end

  def twitter_authenticated_request_parsed(method)
    parse_body(twitter_request_authenticated(method))
  end

end
