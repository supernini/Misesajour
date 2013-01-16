class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.references  :user_twitter
      t.integer     :twitter_id
      t.string      :name
      t.string      :screen_name
      t.string      :url
      t.integer     :followers_count
      t.integer     :friends_count
      t.integer     :status_count
      t.string      :lang, :limit => 2
      t.datetime    :last_tweet_date
      t.boolean     :following
      t.boolean     :follow_request_send
      t.datetime    :last_import
      t.boolean     :follow_user
      t.timestamps
    end
    add_index :followers, :user_twitter_id
  end
end
