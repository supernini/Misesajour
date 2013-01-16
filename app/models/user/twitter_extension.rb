module User::TwitterExtension

  def twitter_user
    Rails.cache.fetch("twitter_user_#{self.uid}", expires_in: '') do
    Twitter.user(self.uid)
  end
end

def self.oauth_twitter_provider(auth, signed_in_resource=nil)
  user_twitter = UserTwitter.where('provider = ? and uid = ?', auth.provider, auth.extra.raw_info.id).first
  unless user_twitter
    if signed_in_resource
      user = signed_in_resource
    else
      user = User.new
      user.password = Devise.friendly_token[0,20]
      user.email = auth.uid+'@twitter.com'
    end
    user.user_twitters.build(
        :username => auth.info.nickname,
        :provider => auth.provider,
        :uid => auth.extra.raw_info.id,
        :twitter_token => auth.extra.access_token.token,
        :twitter_secret_token => auth.extra.access_token.secret,
        :image_url => auth.extra.raw_info.profile_image_url
    )
    user.save
  else
    user = user_twitter.user
  end
  user
end

private

def invite_message(url)
  "Do you beleive in the flying spaghetti monster? Become a faithful, the Pastafarian is awaiting for you here: #{SmallLink.shrink_url(url)}"
end
end