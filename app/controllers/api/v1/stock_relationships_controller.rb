class Api::V1::StockRelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :current_user

  def create
    stock = Stock.find_by(symbol: params[:id])
    if !current_user.following_stock?(stock)
      stock.add_follower(current_user)

      
      render json: {
        user:user_response(current_user),
        messages:["#{stock.symbol}をフォローしました"],
        loggedIn: true,
      }, status:200
    else
      render json: {messages:["すでに#{stock.symbol}をフォローしています"]}, status: 202
    end

  end

  def destroy
    stock = Stock.find_by(symbol: params[:id])
    
    if current_user.following_stock?(stock)
      stock.delete_follower(current_user)
      render json: {
        user: user_response(current_user),
        messages:["#{stock.symbol}のフォローを解除しました"],
        loggedIn: true,
      }, status:200
    else
      render json: {messages:["まだ#{stock.symbol}をフォローしていません"]}, status: 202
    end
  end

end
