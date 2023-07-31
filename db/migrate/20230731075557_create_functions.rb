class CreateFunctions < ActiveRecord::Migration[7.0]
  def change
    create_table :functions do |t|
      t.string :expression, default: '1'
      t.integer :classification, default: 0
      t.string :antiderivative, default: 'x'
    end
  end
end
