class Api::V1::StocksController < ApplicationController
  before_action :logged_in_user, only:[:show, :my_following_stock ]
  before_action :current_user


  def show

    symbol = params[:id].upcase

    @stock = Stock.find_by(symbol: symbol)

    if @stock
      @financial_data = get_financial_data(symbol, @stock)

      render json:{
        messages:["#{@stock.symbol}の情報を取得しました。"],
        stock: @stock,
        isFollowingStock:@stock.is_following_by_user?(current_user),
        earnings: @financial_data
      }, status: 200
    else
      render json:{
        messages:["シンボル[#{symbol}]の情報は取得できません"]
      },status:202
    end

  end

  def my_following_stock
    stocks = current_user.stocks
    if stocks

      my_following_stocks_price = getMyStocksPrice(stocks)

      render json:{
        messages:["フォローしている株式を取得しました"],
        stocks: my_following_stocks_price
      }
    else
      render json:{
        messages:["フォローしている株式がありません"]
      }
    end
  end

  # 日足チャート用のdaily株価を取得
  def stock_historical_price

    response = get_historical_price(params[:symbol], params[:day])

    if response["symbol"] == params[:symbol]  
      render json:{
        symbol: response["symbol"],
        historical: response["historical"],
        messsages: ["daily株価データを取得しました。"]
      }

    else
      render json:{
        messages:["株式情報が取得できません"]
      }
    end
  end

  private #####################################################################
    

    def get_financial_data(_symbol,stock)

      symbol = _symbol.upcase
      last_reported_financial_datum = FinancialDatum.order(endOfQuarter: :desc).where(symbol: symbol).where.not(revenue:nil).first
      last_estimated_financial_datum = FinancialDatum.order(endOfQuarter: :desc).where(symbol: symbol).where.not(revenueEstimated: nil).first

      last_reported_date = last_reported_financial_datum ? last_reported_financial_datum.date : Date.today
      last_estimate_date = last_estimated_financial_datum ? last_estimated_financial_datum.date : Date.today

      # 120日以上前が最新データならデータを更新する
      is_missing_reported_data = (Date.today - last_reported_date) >= 120
      is_missing_estimated_data = (Date.today - last_estimate_date) >= 120
                  
      if last_estimated_financial_datum.nil? || is_missing_estimated_data
        # FinancialDatum.import_api_data("analyst-estimates", symbol,stock)
      end

      if last_reported_financial_datum.nil? || is_missing_reported_data
        # FinancialDatum.import_api_data("enterprise-values", symbol,stock)
        FinancialDatum.import_api_data("financial-growth", symbol,stock,"endOfQuarter")
        FinancialDatum.import_api_data("historical/earning_calendar",symbol,stock,"announcementDate")
        FinancialDatum.import_api_data("income-statement",symbol,stock,"endOfQuarter")
        FinancialDatum.import_api_data("cash-flow-statement", symbol,stock,"endOfQuarter")
      end

      return Stock.find_by(symbol: symbol).financial_data
    end



    # APIからフォローしている株式の価格情報を取得する
    def getMyStocksPrice(stocks)

      base_url = ENV["API_URL"]
      api_key = ENV["API_KEY"]

      symbols = []

      stocks.each do |stock|
        symbols.push(stock.symbol)
      end

      symbols_url = symbols.join(",")
      
      uri = URI.parse("#{base_url}/quote/#{symbols_url}?apikey=#{api_key}")
      request = Net::HTTP::Get.new(uri)
      request["Upgrade-Insecure-Requests"] = "1"
      
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      return JSON.parse(response.body)
      
    end

    def get_historical_price(symbol, day)

      base_url = ENV["API_URL"]
      api_key = ENV["API_KEY"]

      uri = URI.parse("#{base_url}/historical-price-full/#{symbol}?timeseries=#{day}&apikey=#{api_key}")
      request = Net::HTTP::Get.new(uri)
      request["Upgrade-Insecure-Requests"] = "1"
      
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      return JSON.parse(response.body)
      
    end


end
