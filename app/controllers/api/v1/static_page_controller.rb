class Api::V1::StaticPageController < ApplicationController

  def home
    render json: {text: "This is home!!"}
  end

  def help
    render json: {text: "This is help"}
  end
end
