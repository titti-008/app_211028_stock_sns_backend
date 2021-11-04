class ApplicationController < ActionController::API
  
  def hello_world
    render json: { text: "hello world!!!!"}
  end

  def home
    render json: {text: "This is home!!"}
  end

  def help
    render json: {text: "This is help"}
  end
end
