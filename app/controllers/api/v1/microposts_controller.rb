class Api::V1::MicropostsController < ApplicationController
  before_action :logged_in_user, only:[:index, :create, :destroy, ]
  before_action :correct_user, only:[:destroy]

  def index
    _microposts =get_users_microposts(@current_user, params[:current_limit])
    @microposts = microposts_response(_microposts)
    render json: {
      microposts: @microposts,
      messages: ["フィードを取得しました"]
    }, status:200
  end

  def create
    @micropost = @current_user.microposts.build(micropost_params)
    params[:images].each do |params_image|

      @micropost.images.attach(params_image)
    end
    if @micropost.save
      render json: {
        messages:["呟きを投稿しました。"]
      }, status: 200
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
    # debugger
    params.permit(:content, :images)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id:params[:id])
    if @micropost.nil?
      render json: {messages: ["ログインユーザーの投稿しか削除できません"]} ,status:202
    end
  end
end
