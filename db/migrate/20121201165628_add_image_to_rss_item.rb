class AddImageToRssItem < ActiveRecord::Migration
  def change
    add_column :rss_items, :image, :string
  end
end
