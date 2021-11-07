class Api::V1::SessionsController < ApplicationController



  def login
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      login!
      render json:  { loggedIn: true, user: {
        id: @user.id, 
        name: @user.name,
        email: @user.email,
        createdAt: @user.created_at,
      }}
    else
      render json: { status: 401, errors:["認証に失敗しました。","正しいメールアドレスとユーザー名を入力するか、新規登録を行ってください。"]}
    end
  end

  def logout
    reset_session
    render json: { status: 200, loggedIn: false, message: "ログアウトしました" }
  end

  def logged_in?
    
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end

    if @current_user
      render json: { loggedIn: true, user: {
        id: @current_user.id, 
        name: @current_user.name,
        email: @current_user.email,
        createdAt: @current_user.created_at,
      }}
    else
      render json: { loggedIn: false, message: "ユーザーが存在しません" }
    end
  end


  private ###########################3

    def session_params
      params.require(:user).permit(:name, :email, :password)
    end
end
