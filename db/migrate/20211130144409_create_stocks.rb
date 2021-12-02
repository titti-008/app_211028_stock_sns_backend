class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string :symbol,uniqueness: true, nil:false
      t.string :name
      t.string :country
      t.integer :ipoYear
      t.string :sector
      t.string :industry
      # t.date :lastReportedDate
      # t.date :nextReportDate

      t.timestamps
    end
    add_index :stocks, [:symbol]
  end
end
