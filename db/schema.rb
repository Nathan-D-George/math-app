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

ActiveRecord::Schema[7.0].define(version: 2023_08_08_103727) do
  create_table "conversions", force: :cascade do |t|
    t.string "rectangular", default: "z = x+y"
    t.string "cylindrical", default: "z = rcos(θ)+rsin(θ)"
    t.string "spherical", default: "z = ρsin(φ)cos(θ) + ρsin(φ)sin(θ)"
  end

  create_table "equations", force: :cascade do |t|
    t.string "expression", default: "x = 1"
    t.string "solution", default: "x = 1"
  end

  create_table "functions", force: :cascade do |t|
    t.string "expression", default: "x"
    t.integer "classification", default: 0
    t.string "antiderivative", default: "0.5*x^2"
    t.string "derivative", default: "1"
  end

  create_table "sequences", force: :cascade do |t|
    t.string "start_terms"
    t.string "rule"
    t.integer "nth_term"
  end

end
