class RssItem < ActiveRecord::Base
  belongs_to :rss_provider
  has_one :rss_twitt
  attr_accessible :description, :link, :pubdate, :title, :twitt_count
end
