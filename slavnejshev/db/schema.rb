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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161022100052) do

  create_table "private_folders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.string   "full_path"
    t.integer  "owner_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "public",           default: false
    t.boolean  "stores_panoramas", default: false
    t.index ["full_path"], name: "index_private_folders_on_full_path", unique: true, using: :btree
    t.index ["parent_id"], name: "index_private_folders_on_parent_id", using: :btree
  end

  create_table "private_pano_versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "description", limit: 65535
    t.integer  "panorama_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "idx"
    t.index ["idx"], name: "index_private_pano_versions_on_idx", using: :btree
    t.index ["panorama_id", "idx"], name: "index_private_pano_versions_on_panorama_id_and_idx", unique: true, using: :btree
    t.index ["panorama_id"], name: "index_private_pano_versions_on_panorama_id", using: :btree
  end

  create_table "private_panoramas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.integer  "folder_id"
    t.string   "full_path"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["folder_id"], name: "index_private_panoramas_on_folder_id", using: :btree
    t.index ["full_path"], name: "index_private_panoramas_on_full_path", unique: true, using: :btree
  end

  create_table "private_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "admin",           default: false
    t.index ["name"], name: "index_private_users_on_name", unique: true, using: :btree
  end

end
