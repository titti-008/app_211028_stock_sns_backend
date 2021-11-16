class Api::V1::UsersController < ApplicationController
  before_action :current_user, only: [:update, :destroy]
  before_action :admin_user, only: [:destroy]


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

    @users = get_users()
    render json: {users: @users, messages:["ユーザー一覧を表示します"]}, status: 200
  end


  def create
    @user = User.new(user_params)
    
    if @user.save
      log_in @user
      render json: { user:{
        id: @user.id, 
        name: @user.name,
        email: @user.email,
        createdAt: @user.created_at,
        admin: @user.admin
        }, messages:["ユーザー情報が登録できました"]  }, 
        status: 200

    else
      puts @user.errors.full_messages
      render json: {messages: @user.errors.full_messages }, status: 202

    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @name= @user.name
    if @user.destroy
      @users = get_users
      render json: {messages:["ユーザー(#{@name})を削除しました。"], users: @users}, status:200
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
          admin: @user.admin
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

    def admin_user
      if !current_user.admin?
        render json: { messages:["管理者以外ユーザーの削除はできません。"]}, status: 202
      end

    end

    def get_users
      @users = []

      User.all.each do |_user|
        @user = {
          id: _user.id,
          name: _user.name,
          createdAt: _user.created_at,
          admin: _user.admin,
          email: _user.email
        }
        @users.push(@user)
      end
      return @users
    end

end
