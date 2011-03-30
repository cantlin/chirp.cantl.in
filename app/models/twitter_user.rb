class TwitterUser < ActiveRecord::Base
  attr_accessible :twitter_id, :screen_name, :name, :image, :location, :status
  belongs_to :user
end
