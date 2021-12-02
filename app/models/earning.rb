class Earning < ApplicationRecord
  belongs_to :stock
  validates :symbol, presence: true
  validates :fiscalDateEnding, presence: true, uniqueness: {scope: :symbol}
  default_scope -> { order(fiscalDateEnding: :desc) }



  def self.import_api_data(function,period, _symbol,stock)

    symbol = _symbol.upcase

    client = self.client()
    data = client.get(function, symbol: symbol)
    period_data = data[period]

    period_data.map do |row|
      earning = find_by(symbol: symbol, fiscalDateEnding: row["fiscalDateEnding"] ) || new
      earning.symbol = symbol
      earning.stock_id = stock.id
      earning.attributes = row.to_hash.slice(*updatable_attributes)

      earning.save

    end

  end


  private  ########################################################################

  def self.client
    return Avantage::Client.new(ENV["API_ACCESS_KEY"])
  end


  # 更新を許可するカラムを定義
  def self.updatable_attributes
    [
      # EARNINGS
      "symbol",
      "fiscalDateEnding",
      "reportedDate",
      "reportedEPS",
      "estimatedEPS",
      "surprise",
      "surprisePercentage",

      # INCOME_STATEMENT
      "reportedCurrency",
      "totalRevenue",
      "costOfRevenue",
      "operatingIncome",
      "grossProfit",

      # CASH_FLOW
      "operatingCashflow",
      "netIncome",


    ]
  end



end
