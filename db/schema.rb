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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150417035819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string "remote_id"
    t.string "name"
    t.string "url"
    t.string "fare_url"
    t.string "timezone"
    t.string "language"
    t.string "phone"
  end

  create_table "routes", force: :cascade do |t|
    t.integer  "remote_id"
    t.string   "short_name"
    t.string   "long_name"
    t.string   "description"
    t.string   "route_type"
    t.string   "url"
    t.string   "color"
    t.string   "text_color"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "agency_id"
  end

  add_index "routes", ["agency_id"], name: "index_routes_on_agency_id", using: :btree

  create_table "stop_times", force: :cascade do |t|
    t.time     "arrival_time"
    t.time     "departure_time"
    t.string   "stop_sequence"
    t.string   "stop_headsign"
    t.integer  "pickup_type"
    t.integer  "drop_off_type"
    t.float    "shape_dist_traveled"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "agency_id"
    t.integer  "stop_id"
    t.integer  "trip_id"
  end

  add_index "stop_times", ["agency_id"], name: "index_stop_times_on_agency_id", using: :btree
  add_index "stop_times", ["stop_id"], name: "index_stop_times_on_stop_id", using: :btree
  add_index "stop_times", ["trip_id"], name: "index_stop_times_on_trip_id", using: :btree

  create_table "stops", force: :cascade do |t|
    t.string   "remote_id"
    t.integer  "code"
    t.string   "name"
    t.string   "description"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "zone_id"
    t.string   "url"
    t.integer  "location_type"
    t.string   "parent_station"
    t.string   "timezone"
    t.integer  "wheelchair_boarding"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "agency_id"
  end

  add_index "stops", ["agency_id"], name: "index_stops_on_agency_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.integer  "remote_id"
    t.integer  "service_id"
    t.string   "headsign"
    t.string   "short_name"
    t.integer  "direction_id"
    t.integer  "block_id"
    t.integer  "shape_id"
    t.integer  "wheelchair_accessible"
    t.integer  "bikes_allowed"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "agency_id"
    t.integer  "route_id"
  end

  add_index "trips", ["agency_id"], name: "index_trips_on_agency_id", using: :btree
  add_index "trips", ["route_id"], name: "index_trips_on_route_id", using: :btree

end
