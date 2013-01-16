class AddUserTwitterToRssProvider < ActiveRecord::Migration
  def change
    add_column :rss_providers, :user_twitter_id, :integer
  end
end
