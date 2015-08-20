class AuthMailer < ApplicationMailer
  def ios_login user
    @user = user
    mail to: @user.email, subject: "Iron Directory login link"
  end
end
