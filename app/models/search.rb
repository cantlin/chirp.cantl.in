class Search < ActiveRecord::Base
  include RequestsHelper, SessionsHelper
  attr_accessible :query
  before_save :set_user_id

  def results
    (search_twitter_for query).map do |user|
      { :screen_name => user['from_user'],
        :image => user['profile_image_url'],
        :status => user['text']
      # :following => (@current_user && @current_user.following.find {|a| a.value? user['from_user_id']}) ? 1 : nil
      }
    end
  end

  def set_user_id
    user_id = (@current_user.nil?) ? nil : @current_user.id
  end

end
