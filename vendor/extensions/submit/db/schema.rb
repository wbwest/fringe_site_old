# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 21) do

  create_table "cats", :force => true do |t|
    t.string "name"
    t.text   "description"
    t.string "created_at"
    t.string "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.integer  "project_id",  :limit => 11
    t.string   "description"
    t.datetime "created_at"
  end

  add_index "logs", ["project_id"], :name => "fk_logs_projects"

  create_table "project_comments", :force => true do |t|
    t.integer  "project_id",  :limit => 11, :null => false
    t.integer  "user_id",     :limit => 11, :null => false
    t.datetime "date_posted",               :null => false
    t.text     "comment",                   :null => false
  end

  create_table "projects", :force => true do |t|
    t.integer  "user_id",        :limit => 11
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cat_id",         :limit => 11
    t.text     "youtube_videos"
    t.boolean  "published",                    :default => false
  end

  add_index "projects", ["user_id"], :name => "fk_orders_users"
  add_index "projects", ["cat_id"], :name => "fk_projects_categories"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "profile"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
    t.string   "picture"
    t.boolean  "change_password", :default => false
    t.datetime "last_login"
    t.boolean  "new_user",        :default => true
    t.boolean  "filter_news",     :default => false
  end

  create_table "votes", :id => false, :force => true do |t|
    t.integer  "user_id",    :limit => 11, :null => false
    t.integer  "project_id", :limit => 11, :null => false
    t.datetime "created_at"
  end

  add_index "votes", ["project_id"], :name => "fk_votes_projects"

end
