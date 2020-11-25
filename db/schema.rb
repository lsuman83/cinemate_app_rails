# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_20_145423) do

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.integer "release_year"
    t.string "mpaa_rating"
    t.text "description"
    t.string "genre"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.string "name"
    t.text "image"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "watch_list_movies", force: :cascade do |t|
    t.boolean "watched", default: false
    t.integer "watch_list_id", null: false
    t.integer "movie_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["movie_id"], name: "index_watch_list_movies_on_movie_id"
    t.index ["watch_list_id"], name: "index_watch_list_movies_on_watch_list_id"
  end

  create_table "watch_lists", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_watch_lists_on_user_id"
  end

  add_foreign_key "watch_list_movies", "movies"
  add_foreign_key "watch_list_movies", "watch_lists"
  add_foreign_key "watch_lists", "users"
end
