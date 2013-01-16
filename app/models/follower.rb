class Follower < ActiveRecord::Base
  belongs_to :user_twitter
  attr_accessible :follow_request_send, :followers_count, :following, :friends_count, :twitter_id, :lang, :last_tweet_date, :name, :screen_name, :status_count, :url, :follow_user

  validates_uniqueness_of :twitter_id, :scope => [:user_twitter_id]
end
