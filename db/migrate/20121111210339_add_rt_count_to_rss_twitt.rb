class AddRtCountToRssTwitt < ActiveRecord::Migration
  def change
    add_column :rss_twitts, :rt_count, :integer, :default => 0
  end
end
