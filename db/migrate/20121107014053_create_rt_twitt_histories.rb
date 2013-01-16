class CreateRtTwittHistories < ActiveRecord::Migration
  def change
    create_table :rt_twitt_histories do |t|
      t.references :rt_twitt
      t.datetime :to_send_at
      t.string :send_at
      t.text :twitt

      t.timestamps
    end
    add_index :rt_twitt_histories, :rt_twitt_id
  end
end
