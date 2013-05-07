class Account::AccountController < ApplicationController
  before_filter :authenticate
  
  def edit
    @account = current_account
  end
  
  def update
    @account = current_account
    
    if @account.update_attributes(params[:account])
      redirect_to account_root_path, :notice => 'Account updated successfully!'
    else
      render :index
    end
  end
  
  def regenerate
    @account = current_account
    @account.regenerate_api_secret
    
    if @account.save
      @response = @account
    else
      @response = @account.errors
    end
    
    respond_to do |format|
      format.html { redirect_to account_root_path, :notice => 'Account updated successfully!' }
      format.json { render :json => @response }
    end
  end
end