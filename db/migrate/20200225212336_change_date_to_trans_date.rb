class ChangeDateToTransDate < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :date, :trans_date
  end
end
