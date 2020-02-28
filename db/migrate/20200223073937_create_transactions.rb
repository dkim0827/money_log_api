class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :trans_type
      t.datetime :trans_date
      t.string :category
      t.text :description
      t.decimal :amount, precision: 10, scale: 2

      t.references :statement, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
