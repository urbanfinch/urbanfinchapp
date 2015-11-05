class AuthenticationController < ApplicationController
  layout "authentication"

  def login
    render
  end

  def login_create
    user = User.authenticate(params[:username_or_email], params[:password])

    if user
      if params[:remember]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to root_url
    else
      redirect_to login_url, :notice => 'Incorrect username, email or password.'
    end
  end

  def login_destroy
    cookies.delete(:auth_token)
    redirect_to login_url
  end

  def recover
    render
  end

  def recover_process
    user = User.where(:email => params[:email]).first
    user.send_reset if user
    redirect_to login_url, :notice => 'Password recovery information has been sent to your email address.'
  end

  def reset
    @user = User.where(:reset_token => params[:reset_token]).first
    unless @user
      redirect_to recover_path, :notice => 'Password recover token not found.'
    end
  end

  def reset_process
    @user = User.where(:reset_token => params[:reset_token]).first
    if @user && @user.reset_time < 2.hours.ago
      redirect_to token_recover_path(:token => current_account.token), :notice => 'Password reset has expired.'
    elsif @user && @user.update_attributes(:password => params[:password], :password_confirmation => params[:password_confirmation])
      redirect_to token_login_path(:token => current_account.token), :notice => 'Password has been reset!'
    else
      render :reset
    end
  end
end
