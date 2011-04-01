class AddResultsToSearch < ActiveRecord::Migration
  def self.up
    add_column :searches, :results, :string
  end

  def self.down
    remove_column :searches, :results
  end
end
