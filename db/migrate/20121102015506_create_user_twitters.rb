class CreateUserTwitters < ActiveRecord::Migration
  def change
    create_table :user_twitters do |t|
      t.references :user
      t.string :username
      t.string :twitter_token
      t.string :twitter_secret_token
      t.string :public_token
      t.string :provider
      t.integer :uid
      t.string :image_url

      t.timestamps
    end
    add_index :user_twitters, :user_id
  end
end
