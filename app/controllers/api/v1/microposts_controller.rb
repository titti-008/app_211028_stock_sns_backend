class Api::V1::MicropostsController < ApplicationController
  before_action :logged_in_user, only:[:index, :create, :destroy, ]

  def index
    @microposts = microposts_response(@current_user.microposts)
    render json: {
      microposts: @microposts,
      messages: ["フィードを取得しました"]
    }, status:200
  end

  def create
    @micropost = @current_user.microposts.build(micropost_params)
    if @micropost.save
      render json: {
        messages:["呟きを投稿しました。"]
      }, status: 200
    else
      render json:{messages: @miropost.errors.full_messages} ,status:202
    end
  end

  def destroy

  end









  private ####################

  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
