class ChangeTypeNameToTransType < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :type, :trans_type
  end
end
