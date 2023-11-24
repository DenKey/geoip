# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_24_131450) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "domains", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains_ip_addresses", force: :cascade do |t|
    t.bigint "domain_id"
    t.bigint "ip_address_id"
    t.index ["domain_id"], name: "index_domains_ip_addresses_on_domain_id"
    t.index ["ip_address_id"], name: "index_domains_ip_addresses_on_ip_address_id"
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.inet "address", null: false
    t.integer "ip_type", null: false
    t.point "coordinate", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coordinate"], name: "index_ip_addresses_on_coordinate", using: :gist
  end

  add_foreign_key "domains_ip_addresses", "domains"
  add_foreign_key "domains_ip_addresses", "ip_addresses"
end
