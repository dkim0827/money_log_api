class ChangeColumnNameTransaction < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :transaction_type, :type
    rename_column :transactions, :transaction_date, :date
  end
end
