class Api::V1::SessionsController < ApplicationController



  def login
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      login! @user
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
    session.delete(:user_id)
    @current_user = nil
    render json: { status: 200, loggedIn: false, message: "ログアウトしました" }
  end

  def logged_in?
    
      @current_user ||= User.find_by(id: session[:user_id])
    
    if @current_user
      render json: { loggedIn: true, user: {
        id: @current_user.id, 
        name: @current_user.name,
        email: @current_user.email,
        createdAt: @current_user.created_at,
      }}
    else
      render json: { status:401, loggedIn: false, message: "ユーザーが存在しません" }
    end
  end


  private ###########################3

    def session_params
      params.require(:user).permit( :email, :password)
    end
end
