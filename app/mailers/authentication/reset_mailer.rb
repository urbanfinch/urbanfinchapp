class Authentication::ResetMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset.subject
  #
  def reset(user)
    @user = user
    mail to: user.email, :subject => 'Cashier Account Recovery'
  end
end
