class Api::V1::StockRelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :current_user

  def create
    stock = Stock.find_by(symbol: params[:id])
    if !current_user.following_stock?(stock)
      stock.add_follower(current_user)
      render json: {
        isFollowingStock: current_user.following_stock?(stock) ,
        messages:["#{stock.symbol}をフォローしました"]
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
        isFollowingStock: current_user.following_stock?(stock),
        messages:["#{stock.symbol}のフォローを解除しました"]
      }, status:200
    else
      render json: {messages:["まだ#{stock.symbol}をフォローしていません"]}, status: 202
    end
  end

end
