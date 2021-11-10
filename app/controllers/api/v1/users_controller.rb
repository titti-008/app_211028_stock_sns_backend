class Api::V1::UsersController < ApplicationController
  before_action :current_user, only: :update


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
      login_user @user
      render json: { user: @user }, status: 201

    else
      render json: {message: @user.errors }, status: 500
    end
  end


  def update
    @user = User.find_by(id: params[:id])

    if current_user?(@user)
      if @user.update(user_params)
        render json: { loggedIn: true, user: {
          id: @current_user.id, 
          name: @current_user.name,
          email: @current_user.email,
          createdAt: @current_user.created_at,
        } }
      else
        render json: { message: @user.errors }, status: 500
      end
      
    else
      render json: {message: "ログインされていません"}, status:500
    end


  end

  private

  ##################
    def user_params
      params.require(:user).permit(:id, :email, :name, :password, :password_confirmation)
    end

    # #正しいユーザーかどうか確認
    # def current_user
    #   @user = User.find_by(id: params[:id])

    # end

end
