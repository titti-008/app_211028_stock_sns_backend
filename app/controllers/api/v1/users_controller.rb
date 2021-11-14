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
      login_user(@user)
      render json: { user:{
        id: @user.id, 
        name: @user.name,
        email: @user.email,
        createdAt: @user.created_at,
        }, messages:["ユーザー情報が登録できました"]  }, 
        status: 201

    else
      puts @user.errors.full_messages
      render json: {messages: @user.errors.full_messages }, status: 500

    end
  end


  def update
    @user = User.find_by(id: params[:id])

    if current_user?(@user)
      if @user.update(user_params)
        render json: { loggedIn: true, user: {
          id: @user.id, 
          name: @user.name,
          email: @user.email,
          createdAt: @user.created_at,
        }, 
        messages: ["ユーザー情報更新完了" ]}, status: 201

      else
        render json: { messages: @user.errors.full_messages}, status: 202
      end
      
    else
      render json: {messages: ["ログインされていません"]}, status:202
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
