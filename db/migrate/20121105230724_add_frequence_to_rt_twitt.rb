class AddFrequenceToRtTwitt < ActiveRecord::Migration
  def change
    add_column :rt_twitts, :frequence, :integer, :default => 0
  end
end
