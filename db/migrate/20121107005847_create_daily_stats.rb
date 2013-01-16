class CreateDailyStats < ActiveRecord::Migration
  def change
    create_table :daily_stats do |t|
      t.references :rss_provider
      t.date :date
      t.integer :twitt
      t.integer :rt

      t.timestamps
    end
    add_index :daily_stats, :rss_provider_id
  end
end
