class Api::V1::UsersController < ApplicationController

  def show
    @user = User.find_by(id: params[:id])
    render json: {
      id: @user.id, 
      name: @user.name,
      email: @user.email,
      createdAt: @user.created_at,
    }
  end

  def index
    @users = []

    User.all.each do |_user|
      @user = {
        id: _user.id,
        name: _user.name,
        createdAt: _user.created_at
      }
      @users.push(@user)
    end
    render json: @users
  end

  def new

  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      render json: @user

    else
      render json: {message: @user.errors }, status: 500
    end
  end

  private

  ##################
    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
      
    end

end
