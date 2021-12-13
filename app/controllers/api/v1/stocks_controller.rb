class Api::V1::StocksController < ApplicationController
  before_action :logged_in_user
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
      render json:{
        messages:["フォローしている株式を取得しました"],
        stocks: stocks
      }
    else
      render json:{
        messages:["フォローしている株式がありません"]
      }
    end

  end

  private #####################################################################

    # def get_earnings(_symbol,stock)

    #   symbol = _symbol.upcase
    #   last_reported_earning = Earning.order(fiscalDateEnding: :desc).where(symbol: symbol).where.not(reportedEPS:nil).first
    #   last_earning_estimate = Earning.order(fiscalDateEnding: :desc).where(symbol: symbol).where(reportedEPS: nil).first

    #   # debugger ##########
    #   if last_earning_estimate.nil?
    #   end

    #   last_reported_date = last_reported_earning ? last_reported_earning.fiscalDateEnding : Date.today
    #   last_estimate_date = last_earning_estimate ? last_earning_estimate.fiscalDateEnding : Date.today
    #   isMissingData = (last_estimate_date - last_reported_date) >= 100

    #   if last_reported_earning.nil? || isMissingData
    #     Earning.import_api_data("CASH_FLOW", "quarterlyReports",symbol,stock)
    #     Earning.import_api_data("INCOME_STATEMENT", "quarterlyReports",symbol,stock)
    #     Earning.import_api_data("EARNINGS", "quarterlyEarnings",symbol,stock)
    #   end

    #   return Stock.find_by(symbol: symbol).earnings

    # end
    

    def get_financial_data(_symbol,stock)

      symbol = _symbol.upcase
      last_reported_financial_datum = FinancialDatum.order(date: :desc).where(symbol: symbol).where.not(revenue:nil).first
      last_estimated_financial_datum = FinancialDatum.order(date: :desc).where(symbol: symbol).where.not(revenueEstimated: nil).first

      # debugger ##########

      last_reported_date = last_reported_financial_datum ? last_reported_financial_datum.date : Date.today
      last_estimate_date = last_estimated_financial_datum ? last_estimated_financial_datum.date : Date.today

      # 120日以上前が最新データならデータを更新する
      is_missing_reported_data = (Date.today - last_reported_date) >= 120
      is_missing_estimated_data = (Date.today - last_estimate_date) >= 120
                  
      if last_estimated_financial_datum.nil? || is_missing_estimated_data
        # FinancialDatum.import_api_data("analyst-estimates", symbol,stock)
      end

      if last_reported_financial_datum.nil? || is_missing_reported_data
        # FinancialDatum.import_api_data("income-statement",symbol,stock)
        # FinancialDatum.import_api_data("cash-flow-statement", symbol,stock)
        # FinancialDatum.import_api_data("enterprise-values", symbol,stock)
        # FinancialDatum.import_api_data("financial-growth", symbol,stock)
        FinancialDatum.import_api_data("historical/earning_calendar",symbol,stock)
      end

      return Stock.find_by(symbol: symbol).financial_data

    end

end
