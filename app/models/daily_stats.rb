class DailyStats < ActiveRecord::Base
  belongs_to :rss_provider
  attr_accessible :date, :rt, :twitt
end
