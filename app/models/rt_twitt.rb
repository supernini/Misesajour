class RtTwitt < ActiveRecord::Base
  belongs_to :rss_provider
  belongs_to :user_twitter
  has_many  :rt_twitt_histories
  attr_accessible :frequence, :user_twitter_id

  #prepare les entrées pour les tweets qui seront envoyé dans la journée
  def self.daily_prepare
    RtTwitt.all.each do |rt_twitt|
      hour = 23
      sum_rand = 0
      rt_twitt.frequence.times do |t|
        my_limit = hour / (rt_twitt.frequence-t+1)
        rand = rand(my_limit)+1
        sum_rand += rand
        #puts "*****limit: #{my_limit} / rand :#{rand} / sum_rand#{sum_rand}"
        hour -= rand
        rt_twitt.rt_twitt_histories.build(:to_send_at => DateTime.tomorrow.at_beginning_of_day.advance(:hours => sum_rand, :minutes => rand(60)))
      end
      rt_twitt.save
    end
  end
end
