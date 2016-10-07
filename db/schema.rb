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

ActiveRecord::Schema.define(version: 20161006222513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "ammos", force: :cascade do |t|
    t.string   "position"
    t.integer  "dojo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dojo_id"], name: "index_ammos_on_dojo_id", using: :btree
  end

  create_table "dojos", force: :cascade do |t|
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "width",                    default: 10
    t.integer  "height",                   default: 10
    t.integer  "active_player_id"
    t.datetime "active_player_updated_at"
    t.boolean  "fast",                     default: false
  end

  create_table "fields", force: :cascade do |t|
    t.integer  "form_id"
    t.string   "label"
    t.boolean  "required"
    t.string   "definition_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "enabled",       default: false
    t.integer  "index",         default: 0
  end

  create_table "forms", force: :cascade do |t|
    t.string   "title"
    t.text     "terms_and_conditions_raw"
    t.text     "thanks_message_raw"
    t.text     "next_steps_raw"
    t.text     "email_message_raw"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "terms_and_conditions_type"
    t.binary   "terms_and_conditions_pdf_blob"
    t.string   "terms_and_conditions_link_url"
    t.boolean  "upcase_names",                  default: false
    t.boolean  "password_allow_alphabets"
    t.integer  "password_maxlength",            default: 4
    t.boolean  "enable_digital_membership",     default: false
    t.boolean  "enable_junior_membership",      default: false
  end

  create_table "forms_libraries", id: false, force: :cascade do |t|
    t.integer "form_id"
    t.integer "library_id"
    t.index ["form_id"], name: "index_forms_libraries_on_form_id", using: :btree
    t.index ["library_id"], name: "index_forms_libraries_on_library_id", using: :btree
  end

  create_table "instructions", force: :cascade do |t|
    t.string   "group"
    t.integer  "form_id"
    t.text     "content_raw"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "libraries", force: :cascade do |t|
    t.string   "library_prefix"
    t.string   "group_name"
    t.string   "url"
    t.string   "api_value"
    t.string   "display_title"
    t.string   "library_phone"
    t.string   "library_email"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "pdf_email"
    t.string   "profile_id_prefix"
  end

  create_table "players", force: :cascade do |t|
    t.integer  "dojo_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "keg"
    t.string   "position"
    t.integer  "direction"
    t.integer  "ammo_count", default: 0
    t.boolean  "alive",      default: true
    t.integer  "user_id"
    t.string   "color"
    t.string   "name"
    t.datetime "died_at"
    t.index ["dojo_id"], name: "index_players_on_dojo_id", using: :btree
  end

  create_table "scripts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "public"
    t.string   "title"
    t.index ["user_id"], name: "index_scripts_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "admin"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
