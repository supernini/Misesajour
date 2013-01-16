class AddIsRssToRssProvider < ActiveRecord::Migration
  def change
    add_column :rss_providers, :is_rss, :boolean, :default => true
  end
end
