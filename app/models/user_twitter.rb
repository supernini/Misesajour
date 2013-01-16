class UserTwitter < ActiveRecord::Base
  belongs_to :user
  has_many :rss_providers
  has_many :followers
  has_many :rt_twitts
  attr_accessible :image_url, :provider, :public_token, :twitter_secret_token, :twitter_token, :uid, :username

  def get_follower
    @client = Twitter::Client.new(:oauth_token => self.twitter_token, :oauth_token_secret => self.twitter_secret_token)
    @client.followers.each do |follow|
      self.save_follower_info(follow, true)
    end
  end

  def save_follower_info(follow, my_follower)
    self.followers.create(
      :follow_request_send => follow.attrs[:follow_request_sent],
      :followers_count => follow.attrs[:followers_count],
      :following => follow.attrs[:following],
      :friends_count => follow.attrs[:friends_count],
      :twitter_id => follow.attrs[:id],
      :lang => follow.attrs[:lang],
      :last_tweet_date => follow.attrs[:status][:created_at],
      :name => follow.attrs[:name],
      :screen_name => follow.attrs[:screen_name],
      :status_count => follow.attrs[:statuses_count],
      :url => follow.attrs[:url],
      :follow_user => my_follower
    )
  end

  def get_follower_of_follower
    @client = Twitter::Client.new(:oauth_token => self.twitter_token, :oauth_token_secret => self.twitter_secret_token)
    self.followers.where("last_import<NOW() or ISNULL(last_import)").order('followers_count DESC').limit(5).each do |followed|
      @client.followers(followed.twitter_id).each do |follow|
        self.save_follower_info(follow, false)
      end
    end
  end
end
