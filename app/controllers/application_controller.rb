class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::Helpers
  helper_method :log_in, :current_user, :current_user?, :remember, :log_out, 
                :forgot, :login?,:micropost_response, :microposts_response,
                :logged_in_user, :user_response, :get_users_microposts,:images_response


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

  def logged_in_user
    unless login?
      render json: { loggedIn: false, user: nil, messages:["ログインされていません。"]}, status: 202
    end
  end


  def images_response(_images)
    images = []

    _images.each do |_image|
      image = url_for(_image)
      images.push(image)
    end
    return images
  end



  # ユーザーに渡すマイクロソフトを整形・・・ユーザー情報もつけて渡す
  def micropost_response(_micropost)
    
    images = _micropost.images.attached? ? images_response(_micropost.images) : nil

    @micropost= {
      id: _micropost.id,
      content: _micropost.content,
      createdAt: _micropost.created_at,
      user: {
        id:_micropost.user.id,
        name:_micropost.user.name,
      },
      images: images,
    }
    return @micropost
  end

  # ユーザーに渡すマイクロソフトを整形・・・ユーザー情報もつけて渡す
  def microposts_response(microposts)
    @microposts = []
    microposts.each do |_micropost|
        @micropost= micropost_response(_micropost)
        @microposts.push(@micropost)
    end
    return @microposts
  end

  def user_response(_user)
    user = {
      id: _user.id, 
      name: _user.name,
      email: _user.email,
      createdAt: _user.created_at,
      admin: _user.admin,
      countMicroposts: _user.microposts.count,
      countFollowers: _user.followers.count,
      countFollowing: _user.following.count,
    }
    return user
  end


  def get_users_microposts(user_id, current_limit)
    Micropost.where(user_id: user_id).limit(20).offset(current_limit)
  end


  
  def hello_world
    render json: { text: "hello world!!!!"}
  end

end
