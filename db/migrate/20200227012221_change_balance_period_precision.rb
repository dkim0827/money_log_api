class ChangeBalancePeriodPrecision < ActiveRecord::Migration[6.0]
  def self.up
    change_column :users, :balance, :decimal, precision: 10, scale: 2
    change_column :transactions, :amount, :decimal, precision: 10, scale: 2

  end
end
