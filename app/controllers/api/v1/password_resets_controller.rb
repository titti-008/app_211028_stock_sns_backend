class Api::V1::PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:update]
  before_action :valid_user, only: [:update]
  before_action :check_expiration, only: [:update] 

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      render json: {
        messages:["パスワード再設定メールを送付しました。","メールからパスワードの再設定を行ってください。"]
      }, status: 200
    else
      render json: {
        messages:["メールアドレスが存在しません。","正しいメールアドレスを入力するか新規にユーザーを作成してください。"]
      }, status: 202
    end
  end


  def update
    if params[:user][:password].empty?          
      @user.errors.add(:password, :blank)
      render json:  { loggedIn:false, messages: @user.errors.full_messages}, status: 202
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil) #再設定が完了したらreset_digestを消去し再利用できなくする
      render json:  { loggedIn: true, messages:[
        "パスワードを変更しました",
        "ログインしました。",
        "やぁ、#{@user.name}"
      ] ,user: {
        id: @user.id, 
        name: @user.name,
        email: @user.email,
        createdAt: @user.created_at,
        admin: @user.admin
      }}, status:200
    else
      render json:  { loggedIn:false, messages:@user.errors.full_messages}, status: 202
    end
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end


  
  ##############################################
  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end


    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        render json: { loggedIn:false, messages:["パスワード有効化URLの期限が切れています。","再度パスワードの再設定を行ってください。"]}, status:202
      end
    end


end
