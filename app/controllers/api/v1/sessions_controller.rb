class Api::V1::SessionsController < ApplicationController

  def login
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      if @user.activated?
        log_in @user
        current_user
        params[:user][:rememberMe] == 'on' ? remember(@user) : forget(@user)
        render json:  { loggedIn: true, messages:[
          "ログインしました。",
          "やぁ、#{@current_user.name}"
        ] ,user: user_response(@current_user)
      }
      else
        render json:  {  messages:["アカウントが有効化されていません。","登録されたメールアドレスに送られたメールからアカウントの有効化を行ってください。"]}, status: 202
      end

    else
      render json:  {  messages:["認証に失敗しました。","正しいメールアドレスとユーザー名を入力するか、新規登録を行ってください。"]}, status: 202
    end
  end

  def logout
    debugger
    log_out if login?
    render json: { loggedIn: false, user: nil,  messages:[ "ログアウトしました", "{@current_user.name} "]}, status: 200
  end

  def logged_in?
    if current_user
      render json: { loggedIn: true, user: user_response(@current_user),
      messages: ["ログイン確認:OK"]
    }, status:200
    else
      render json: {  loggedIn: false, user: nil, messages:["ログインしているユーザーが存在しません"]} ,status: 202
    end
  end


  private ###########################3

    def session_params
      params.require(:user).permit( :email, :password, :id, :rememberMe)
    end
end
