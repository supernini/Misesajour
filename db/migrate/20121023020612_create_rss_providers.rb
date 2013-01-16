class CreateRssProviders < ActiveRecord::Migration
  def change
    create_table :rss_providers do |t|
      t.string      :name
      t.references  :user
      t.string      :title
      t.string      :url
      t.string      :last_build_date
      t.integer     :frequence, :default => 1
      t.integer     :last_run, :default => 0
      t.integer     :run_count, :default => 0
      t.string      :twitt_prefix
      t.string      :twitt_suffix
      t.datetime    :lastdownload
      t.integer     :failcount, :default => 0
      t.timestamps
    end
    add_foreign_key(:rss_providers, :users)
  end
end
