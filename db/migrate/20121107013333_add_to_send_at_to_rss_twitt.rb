class AddToSendAtToRssTwitt < ActiveRecord::Migration
  def change
    add_column :rss_twitts, :to_send_at, :datetime
  end
end
