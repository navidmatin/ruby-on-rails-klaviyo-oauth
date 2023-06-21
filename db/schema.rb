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

ActiveRecord::Schema[7.0].define(version: 2023_06_20_182010) do
  create_table "o_auths", force: :cascade do |t|
    t.text "code_verifier", null: false
    t.text "code_challenge", null: false
    t.text "refresh_token"
    t.text "access_token"
    t.datetime "expires_at"
    t.text "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
