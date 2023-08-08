class CreateConversions < ActiveRecord::Migration[7.0]
  def change
    create_table :conversions do |t|
      t.string :rectangular, default: 'z = x+y'
      t.string :cylindrical, default: 'z = rcos(θ)+rsin(θ)'
      t.string :spherical, default:   'z = ρsin(φ)cos(θ) + ρsin(φ)sin(θ)'
    end
  end
end
