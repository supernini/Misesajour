class CreateRtTwitts < ActiveRecord::Migration
  def change
    create_table :rt_twitts do |t|
      t.references :rss_provider
      t.references :user_twitter

      t.timestamps
    end
    add_index :rt_twitts, :rss_provider_id
    add_index :rt_twitts, :user_twitter_id
  end
end
