class Api::V1::SessionsController < ApplicationController
  before_action :current_user


  def login
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      # login_user(@user)
      render json:  { loggedIn: true, messages:[
        "ログインしました。",
        "やぁ、#{@user.name}"
      ] ,user: {
        id: @user.id, 
        name: @user.name,
        email: @user.email,
        createdAt: @user.created_at,
      }}
    else
      render json:  {  messages:["認証に失敗しました。","正しいメールアドレスとユーザー名を入力するか、新規登録を行ってください。"]}, status: 202
    end
  end

  def logout
    session.delete(:user_id)
    @current_user = nil 
    render json: { loggedIn: false, messages:[ "ログアウトしました" ]}, status: 200
  end

  def logged_in?


      @current_user ||= User.find_by(id: session[:user_id])
    
    if @current_user
      render json: { loggedIn: true, user: {
        id: @current_user.id, 
        name: @current_user.name,
        email: @current_user.email,
        createdAt: @current_user.created_at,
      },
      messages: ["ログイン確認:OK"]
    }, status:200
    else
      render json: {  loggedIn: false, user: nil, messages:["ログインしているユーザーが存在しません"]} ,status: 202
    end
  end


  private ###########################3

    def session_params
      params.require(:user).permit( :email, :password, :id)
    end
end
