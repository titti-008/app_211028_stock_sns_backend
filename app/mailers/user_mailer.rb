class UserMailer < ApplicationMailer

  
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end


  def password_reset(user)
    @user = user
    @url = "#{ENV["FRONT_END_URL"]}/password_resets/#{@user.reset_token}/edit/#{URI.encode_www_form(email: @user.email)}"
    mail to: user.email, subject: "Password reset"
  end
end
