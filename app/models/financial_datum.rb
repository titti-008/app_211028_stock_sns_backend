class FinancialDatum < ApplicationRecord
  belongs_to :stock
  validates :symbol, presence: true
  validates :date, presence: true, uniqueness: {scope: :symbol}
  default_scope -> { order(date: :desc) }

  require 'net/http'
  require 'uri'




  def self.import_api_data(function, _symbol, stock)

    base_url = "https://financialmodelingprep.com/api/v3"
    api_key = ENV["API_KEY"]

    symbol = _symbol.upcase
    
    uri = URI.parse("#{base_url}/#{function}/#{symbol}?period=quarter&limit=60&apikey=#{api_key}")
    request = Net::HTTP::Get.new(uri)
    request["Upgrade-Insecure-Requests"] = "1"
    
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    period_data = JSON.parse(response.body)

    period_data.map do |row|
      datum = find_by(symbol: symbol, date: row["date"] ) || new
      datum.attributes = row.to_hash.slice(*updatable_attributes)
      datum.stock_id = stock.id
      datum.save
    end
  end


  private  ########################################################################


  # 更新を許可するカラムを定義
  def self.updatable_attributes
    [
      # EARNINGS
      "symbol",
      "date",
      "fillingDate",
      "revenue",
      "revenueEstimated",
      "revenueGrowth",
      "eps",
      "epsEstimated",
      "epsgrowth",
      "reportedCurrency",
      "operatingCashFlow",
      "operatingCashFlowGrowth",
      "netIncome",
      "stockPrice",
      "numberOfShares",
      "marketCapitalization"
    ]
  end



end
