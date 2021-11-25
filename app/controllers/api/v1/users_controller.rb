class Api::V1::UsersController < ApplicationController
  before_action :current_user, only: [:update, :destroy]
  before_action :admin_user, only: [:destroy]


  def show
    @user = User.find_by(id: params[:id])
    if @user.activated
      render json: {
        user: user_response(@user),
        messages:["#{@user.name}の情報を取得しました。"]
      }, status:200
    else
      render json: {messages:["アカウントが有効化されていないユーザーです。"]}, status:202

    end
  end

  def index

    @users = get_users()
    render json: {users: @users, messages:["ユーザー一覧を表示します"]}, status: 200
  end


  def create
    @user = User.new(user_params)
    
    if @user.save
      @user.send_activation_email
      render json: { messages: [
        "登録したメールアドレスにアカウント有効化用URLを送付しました。",
        "メールを確認しアカウントの作成を完了させてください。"
      ]}, status: 200

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
        render json: { 
          loggedIn: true, user: user_response(@user) , 
          messages: ["ユーザー情報更新完了" ]
        }, status: 201

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
      
      _users = User.where(activated: true)
      _users.each  do |_user|
        
        @user = {
        id: _user.id, 
        name: _user.name,
        }
        @users.push(@user)
      end
      return @users
    end

end
