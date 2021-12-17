class Api::V1::MicropostsController < ApplicationController
  before_action :logged_in_user, only:[:index, :create, :destroy, :myfeed]
  before_action :correct_user, only:[:destroy]

  # 指定したユーザーの投稿を取得
  def user_show
    all_microposts =get_users_microposts(params[:user_id], params[:current_limit])
    _microposts = all_microposts.paginate(page:params[:page])
    @microposts = microposts_response(_microposts)
    next_id = next_page(all_microposts)
    render json: {
      microposts: @microposts,
      messages: ["ユーザーの投稿を取得しました"],
      nextId: next_id,
    }, status:200
  end


  # 指定したユーザー(current_user)の投稿を取得
  def myfeed
      

    render_myfeed(params[:current_limit])


    


  end





  def create
    @micropost = @current_user.microposts.build(micropost_params)

    if params[:images]
      params[:images].each do |params_image|
  
        @micropost.images.attach(params_image)
      end

    end
    if @micropost.save
      render_myfeed(1)
    else
      render json:{messages: @micropost.errors.full_messages} ,status:202
    end
  end

  def destroy
    @micropost.destroy
    render json: {messages: ["投稿を削除しました"]}, status:200
  end

  private ####################

  def micropost_params
    params.permit(:content, :images)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id:params[:id])
    if @micropost.nil?
      render json: {messages: ["ログインユーザーの投稿しか削除できません"]} ,status:202
    end
  end

  def render_myfeed(current_limit)
    all_microposts =get_myfeed(@current_user, current_limit)
      _microposts = all_microposts.paginate(page:params[:page])
      @microposts = microposts_response(_microposts)
      next_id = next_page(all_microposts)
      render json: {
        microposts: @microposts,
        messages: ["マイフィードを取得しました"],
        nextId: next_id
      }, status:200
  end

end
