class CreateFinancialData < ActiveRecord::Migration[6.1]
  def change
    create_table :financial_data do |t|
      t.string :symbol, nil:false
      t.date :endOfQuarter, nil:false
      t.date :announcementDate
      t.date :date
      t.date :fillingDate
      t.bigint :revenue
      t.bigint :revenueEstimated
      t.float :revenueGrowth
      t.float :eps
      t.float :epsEstimated
      t.float :epsgrowth
      t.string :reportedCurrency
      t.bigint :operatingCashFlow
      t.float :operatingCashFlowGrowth
      t.bigint :netIncome
      t.float :stockPrice
      t.bigint :numberOfShares
      t.bigint :marketCapitalization
      t.references :stock, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
