class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.text :description
      t.decimal :amount
      t.string :expense_type
      t.references :statement, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
