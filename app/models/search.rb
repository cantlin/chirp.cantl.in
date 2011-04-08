class Search < ActiveRecord::Base
  include RequestsHelper, SessionsHelper
  attr_accessible :query
  before_save :set_user_id

  def results(current_user = nil)
    (search_twitter_for query).map do |user|
      { :screen_name => user['from_user'],
        :image => user['profile_image_url'],
        :status => user['text'],
        :following => (!current_user.nil? && current_user.following.any? {|hash| hash[:screen_name] == user['from_user']}) ? 1 : nil
      }
    end
  end

  def set_user_id
    user_id = (@current_user.nil?) ? nil : @current_user.id
  end

end
