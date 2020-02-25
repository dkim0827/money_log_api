class DeleteMonthYearColumnAddPeriodColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :statements, :month
    remove_column :statements, :year

    add_column :statements, :period, :datetime   
  end
end
