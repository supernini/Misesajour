class AddPriorityToRssItem < ActiveRecord::Migration
  def change
    add_column :rss_items, :priority, :decimal, :precision => 6, :scale => 4, :default => 0
  end
end
