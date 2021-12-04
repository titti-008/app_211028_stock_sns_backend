class Api::V1::EarningsController < ApplicationController

  before_action :column_names

  def export_csv
    @earnings = Earning.all
    send_post_csv(@earnings)
  end

  private  ######################################################


    def send_post_csv(earnings)
      scv_data = CSV.generate do |csv|
        csv << @column_names
        earnings.each do |earning|
          csv << earning.attributes.values
        end
      end
      send_data(scv_data, filename:"earnings_data_#{Date.current.strftime("%YYYY%mm%dd_%HH%MM%SS")}.csv")
    end


    def column_names
      @column_names = [
        # EARNINGS
        "id",
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

        "stock_id",

        # time
        "created_at",
        "updated_at",

      ]
    end



end
