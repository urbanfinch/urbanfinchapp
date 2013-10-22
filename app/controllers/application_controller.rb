class ApplicationController < ActionController::Base
  protect_from_forgery
  
  around_filter :scope_current_account
  
  def not_found
    render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found
  end
  
  protected
  
  def authenticate
    unless current_user
      redirect_to login_path
    end
  end
  
  def current_user
    @current_user ||= User.where(:auth_token => cookies[:auth_token], :active => true, :locked => false).first if cookies[:auth_token]
  end
  helper_method :current_user
  
  def current_account
    @current_account ||= Account.where(:token => request.subdomain).first
  end
  helper_method :current_account
  
  def scope_current_account
    if current_account
      Account.current_id = current_account.id
      yield
    else
      not_found
    end
  ensure
    Account.current_id = nil
  end
  
  def track_activity(trackable, action = params[:action])
    current_user.activities.create(:account => current_account, :action => action, :trackable => trackable)
  end
end