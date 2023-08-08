class CreateEquations < ActiveRecord::Migration[7.0]
  def change
    create_table :equations do |t|
      t.string :expression, default: 'x = 1'
      t.string :solution, default: 'x = 1'
    end
  end
end
