class Api::V1::SessionsController < ApplicationController
  before_action :current_user

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end


  def login
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      if @user.activated?
        log_in @user
        params[:user][:remember_me] == 'on' ? remember(@user) : forget(@user)
        render json:  { loggedIn: true, messages:[
          "ログインしました。",
          "やぁ、#{@user.name}"
        ] ,user: {
          id: @user.id, 
          name: @user.name,
          email: @user.email,
          createdAt: @user.created_at,
          admin: @user.admin
        }}
      else
        render json:  {  messages:["アカウントが有効化されていません。","登録されたメールアドレスに送られたメールからアカウントの有効化を行ってください。"]}, status: 202
      end
      
    else
      render json:  {  messages:["認証に失敗しました。","正しいメールアドレスとユーザー名を入力するか、新規登録を行ってください。"]}, status: 202
    end
  end

  def logout
    log_out if login?
    render json: { loggedIn: false, messages:[ "ログアウトしました" ]}, status: 200
  end

  def logged_in?
    if current_user
      render json: { loggedIn: true, user: {
        id: @current_user.id, 
        name: @current_user.name,
        email: @current_user.email,
        createdAt: @current_user.created_at,
        admin: @current_user.admin
      },
      messages: ["ログイン確認:OK"]
    }, status:200
    else
      render json: {  loggedIn: false, user: nil, messages:["ログインしているユーザーが存在しません"]} ,status: 202
    end
  end


  private ###########################3

    def session_params
      params.require(:user).permit( :email, :password, :id, :remember_me)
    end
end
