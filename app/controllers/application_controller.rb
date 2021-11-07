class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::Helpers
  helper_method :login!, :current_user


  # skip_before_action :verify_authenticaty_token

  def login!
    session[:user_id] = @user.id
  end

  def current_user
    debugger
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    
  end




  
  def hello_world
    render json: { text: "hello world!!!!"}
  end

  def home
    render json: {text: "This is home!!"}
  end

end
