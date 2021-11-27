class Api::V1::RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find(params[:id])
    current_user.follow(user)
    render json: {user: user_response(user) ,messages:["フォローしました"]}, status:200
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow(user)
    render json: {user: user_response(user), messages:["フォローを解除しました"]}, status:200
  end

end
