class CreateRssItems < ActiveRecord::Migration
  def change
    create_table :rss_items do |t|
      t.references  :rss_provider
      t.string      :title
      t.text        :description
      t.string      :guid
      t.string      :pubdate
      t.string      :link
      t.integer     :twitt_count, :default => 0
      t.timestamps
    end
    add_foreign_key(:rss_items, :rss_providers)
  end
end
