class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::Helpers
  helper_method :log_in, :current_user, :current_user?, :remember, :log_out, :forgot, :login?


  # skip_before_action :verify_authenticaty_token

  def log_in(user)
    session[:user_id] = user.id
  end





  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end


  def current_user?(user)
    user && user == current_user 
  end


  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(@current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def login?
    !current_user.nil?
  end


  
  def hello_world
    render json: { text: "hello world!!!!"}
  end

  def home
    render json: {text: "This is home!!"}
  end

end
