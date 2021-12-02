class Api::V1::StocksController < ApplicationController

  before_action :client


  def import 
    Stock.import(params[:file])
    redirect_to stocks_path
  end

  def show

    symbol = params[:id].upcase

    @stock = Stock.find_by(symbol: symbol)

    if @stock
      @earnings = get_earnings(symbol, @stock)

      render json:{
        messages:["#{@stock.symbol}の情報を取得しました。"],
        stock: @stock,
        earnings: @earnings
      }, status: 200
    else
      render json:{
        messages:["シンボル[#{symbol}]の情報は取得できません"]
      },status:202
    end


  end


end
