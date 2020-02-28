class CreateStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :statements do |t|
      t.string :title
      t.datetime :period
      t.text :memo
      
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
