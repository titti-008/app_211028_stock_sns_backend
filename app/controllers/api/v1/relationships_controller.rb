class Api::V1::RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find(params[:id])
    if !current_user.following?(user)
      current_user.follow(user)
      render json: {user: user_response(user) ,messages:["フォローしました"]}, status:200
    else
      render json: {messages:["すでにフォローしています"]}, status:202      
    end
  end

  def destroy
    user = User.find(params[:id])
    if current_user.following?(user)
      current_user.unfollow(user)
      render json: {user: user_response(user), messages:["フォローを解除しました"]}, status:200
    else
      render json: {messages:["フォローしているユーザーしかフォローを解除できません"]}, status: 202
    end
  end

end
