class CreateVectors < ActiveRecord::Migration[7.0]
  def change
    create_table :vectors do |t|
      t.integer :magnitude
      t.integer :i
      t.integer :j
      t.integer :k

    end
  end
end
