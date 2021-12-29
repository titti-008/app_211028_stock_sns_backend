class FinancialDatum < ApplicationRecord
  belongs_to :stock
  validates :symbol, presence: true
  validates :endOfQuarter, presence: true, uniqueness: {scope: :symbol}
  default_scope -> { order(endOfQuarter: :desc) }

  require 'net/http'
  require 'uri'




  def self.import_api_data(function, _symbol, stock, dateType )

    base_url = ENV["API_URL"]
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

      end_of_quarter = Date.new
      if dateType == "endOfQuarter"
        # dateが四半期末締日の場合はendOfQuarterにdateを四半期末締日に変換して代入
        end_of_quarter = Date.parse(row["date"]).end_of_quarter 
      elsif dateType == "announcementDate"
        # endOfQuarterには dateの3ヶ月前を起点した四半期末締日を代入
        end_of_quarter = (Date.parse(row["date"]) - 3.month).end_of_quarter
      end  

      datum = find_by(symbol: symbol, endOfQuarter: end_of_quarter ) || new
      datum.endOfQuarter = end_of_quarter
      if dateType == "announcementDate"
        # dateが決算発表日の場合はannouncementDateにdateを代入
        datum.announcementDate = Date.parse(row["date"])
      end
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
