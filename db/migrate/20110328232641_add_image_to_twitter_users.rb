class AddImageToTwitterUsers < ActiveRecord::Migration
  def self.up
    add_column :twitter_users, :image, :string
  end

  def self.down
    remove_column :twitter_users, :image
  end
end
