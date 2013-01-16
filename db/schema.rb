# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130105131232) do

  create_table "daily_stats", :force => true do |t|
    t.integer  "rss_provider_id"
    t.date     "date"
    t.integer  "twitt"
    t.integer  "rt"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "daily_stats", ["rss_provider_id"], :name => "index_daily_stats_on_rss_provider_id"

  create_table "followers", :force => true do |t|
    t.integer  "user_twitter_id"
    t.integer  "twitter_id"
    t.string   "name"
    t.string   "screen_name"
    t.string   "url"
    t.integer  "followers_count"
    t.integer  "friends_count"
    t.integer  "status_count"
    t.string   "lang",                :limit => 2
    t.datetime "last_tweet_date"
    t.boolean  "following"
    t.boolean  "follow_request_send"
    t.datetime "last_import"
    t.boolean  "follow_user"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "followers", ["user_twitter_id"], :name => "index_followers_on_user_twitter_id"

  create_table "rss_items", :force => true do |t|
    t.integer  "rss_provider_id"
    t.string   "title"
    t.text     "description"
    t.string   "guid"
    t.string   "pubdate"
    t.string   "link"
    t.integer  "twitt_count",                                   :default => 0
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.decimal  "priority",        :precision => 6, :scale => 4, :default => 0.0
    t.string   "image"
  end

  add_index "rss_items", ["rss_provider_id"], :name => "rss_items_rss_provider_id_fk"

  create_table "rss_providers", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "title"
    t.string   "url"
    t.string   "last_build_date"
    t.integer  "frequence",       :default => 24
    t.integer  "last_run",        :default => 0
    t.integer  "run_count",       :default => 0
    t.string   "twitt_prefix"
    t.string   "twitt_suffix"
    t.datetime "lastdownload"
    t.integer  "failcount",       :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "is_rss",          :default => true
    t.integer  "user_twitter_id"
  end

  add_index "rss_providers", ["user_id"], :name => "rss_providers_user_id_fk"

  create_table "rss_twitts", :force => true do |t|
    t.string   "twitt"
    t.datetime "send_at"
    t.integer  "rss_provider_id"
    t.integer  "rss_item_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.datetime "to_send_at"
    t.integer  "rt_count",        :default => 0
  end

  add_index "rss_twitts", ["rss_item_id"], :name => "index_rss_twitts_on_rss_item_id"
  add_index "rss_twitts", ["rss_provider_id"], :name => "index_rss_twitts_on_rss_provider_id"

  create_table "rt_twitt_histories", :force => true do |t|
    t.integer  "rt_twitt_id"
    t.datetime "to_send_at"
    t.string   "send_at"
    t.text     "twitt"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "rt_twitt_histories", ["rt_twitt_id"], :name => "index_rt_twitt_histories_on_rt_twitt_id"

  create_table "rt_twitts", :force => true do |t|
    t.integer  "rss_provider_id"
    t.integer  "user_twitter_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "frequence"
  end

  add_index "rt_twitts", ["rss_provider_id"], :name => "index_rt_twitts_on_rss_provider_id"
  add_index "rt_twitts", ["user_twitter_id"], :name => "index_rt_twitts_on_user_twitter_id"

  create_table "user_twitters", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "twitter_token"
    t.string   "twitter_secret_token"
    t.string   "public_token"
    t.string   "provider"
    t.integer  "uid"
    t.string   "image_url"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "user_twitters", ["user_id"], :name => "index_user_twitters_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "fee"
    t.boolean  "payed",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  add_foreign_key "rss_items", "rss_providers", :name => "rss_items_rss_provider_id_fk"

  add_foreign_key "rss_providers", "users", :name => "rss_providers_user_id_fk"

end
