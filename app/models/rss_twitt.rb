class RssTwitt < ActiveRecord::Base
  belongs_to :rss_provider
  belongs_to :rss_item
  attr_accessible :send_at, :twitt, :to_send_at, :rt_count

  scope :sent, where('NOT ISNULL(send_at)')
end
