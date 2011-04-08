class User < ActiveRecord::Base
  include RequestsHelper
  attr_accessible :access_token, :access_token_secret

  validates :access_token, :presence => true
  validates :access_token_secret, :presence => true

  before_save :set_salt, :set_last_login

  def set_salt
    self.salt = BCrypt::Engine.generate_salt if new_record?
  end

  def set_last_login
    self.last_login = Time.now.utc
  end

  def following(cursor = -1)
    Rails.cache.fetch("following/#{id}", :expires_in => 15.minutes) do
      twitter_users = []

      until cursor == 0
        result = parse_body twitter_request_authenticated('get_following', {:cursor => cursor})

        twitter_users.concat((result['users'].map do |user|              
          { :twitter_id => user['id'],
            :screen_name => user['screen_name'],
            :name => user['name'],
            :image => user['profile_image_url'],
            :location => user['location'],
            :following => 1,
            :status => user['status'] ? user['status']['text'] : nil }
          end))

        cursor = result['next_cursor']
      end

      twitter_users
    end
  end

  def following=(value)
    self.following = value
  end

  def unfollow(names)
    names.each do |name|
      twitter_request_authenticated('unfollow', {:screen_name => name}, 'post')
    end
    if Rails.cache.exist? "following/#{id}"
      updated_cache = (Rails.cache.fetch "following/#{id}").reject {|u| names.include? u[:screen_name]}
      Rails.cache.write("following/#{id}", updated_cache)
    end
  end

  def follow(names)
    names.each do |name|
      twitter_request_authenticated('follow', {:screen_name => name}, 'post')
    end
    Rails.cache.delete "following/#{id}"
  end

  def verify
    result = parse_body twitter_request_authenticated('verify_credentials')
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
    @access_token ||= OAuth::AccessToken.new(oauth_consumer, self.access_token, self.access_token_secret)
    method_path = CONFIG['twitter_method_paths'][method_key] # See /config/app_config.yml
    params.each_with_index {|param, i| method_path += "#{(i == 0) ? '?' : '&'}#{param[0]}=#{param[1]}"}
    @access_token.send(method, method_path)
  end

end
