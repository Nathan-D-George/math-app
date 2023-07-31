class CreateFunctions < ActiveRecord::Migration[7.0]
  def change
    create_table :functions do |t|
      t.string  :expression,     default: 'x'
      t.integer :classification, default:  0
      t.string  :antiderivative, default: '0.5*x^2'
      t.string  :derivative,     default: '1'
    end
  end
end
