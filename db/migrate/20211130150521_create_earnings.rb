class CreateEarnings < ActiveRecord::Migration[6.1]
  def change
    create_table :earnings do |t|
      t.string :symbol, nil:false
      t.date :fiscalDateEnding, nil:false
      t.date :reportedDate
      t.float :reportedEPS
      t.float :estimatedEPS
      t.float :surprise
      t.float :surprisePercentage
      t.string :reportedCurrency
      t.bigint :totalRevenue
      t.bigint :costOfRevenue
      t.bigint :operatingIncome
      t.bigint :grossProfit
      t.bigint :operatingCashflow
      t.bigint :netIncome
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
    add_index :earnings, [:symbol]
    add_index :earnings, [:fiscalDateEnding]
    add_index :earnings, [:symbol, :fiscalDateEnding], :unique =>  true 
  end
end
