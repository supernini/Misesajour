class CreateRssTwitts < ActiveRecord::Migration
  def change
    create_table :rss_twitts do |t|
      t.string :twitt
      t.datetime :send_at
      t.references :rss_provider
      t.references :rss_item

      t.timestamps
    end
    add_index :rss_twitts, :rss_provider_id
    add_index :rss_twitts, :rss_item_id
  end
end
