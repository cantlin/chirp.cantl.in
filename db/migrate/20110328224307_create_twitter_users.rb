class CreateTwitterUsers < ActiveRecord::Migration
  def self.up
    create_table :twitter_users do |t|
      t.integer :twitter_id
      t.string :screen_name
      t.string :name
      t.string :location
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_users
  end
end
