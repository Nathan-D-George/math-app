class CreateSequences < ActiveRecord::Migration[7.0]
  def change
    create_table :sequences do |t|
      t.string :start_terms
      t.string :rule
      t.integer :nth_term
    end
  end
end
