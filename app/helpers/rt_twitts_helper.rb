module RtTwittsHelper
  def twitter_present?(user_twitter)
    !@rss_provider.rt_twitts.find_by_user_twitter_id(user_twitter).nil?
  end
end
