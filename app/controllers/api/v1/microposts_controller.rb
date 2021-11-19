class Api::V1::MicropostsController < ApplicationController
  def index
    @user = User.first
    @microposts = microposts_response(@user.microposts)
    render json: {
      microposts: @microposts,
      messages: ["フィードを取得しました"]
    }, status:200
  end


  private ####################3

  def microposts_response(microposts)
    @microposts = []
    microposts.each do |_micropost|
        @micropost= {
          id: _micropost.id,
          content: _micropost.content,
          createdAt: _micropost.created_at,
          user: _micropost.user
        }
        @microposts.push(@micropost)
      end
      return @microposts
  end
end
