class DeleteDateAddTrasnactionDate < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :date

    add_column :transactions, :transaction_date, :datetime 
  end
end
