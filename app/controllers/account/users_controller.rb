class Account::UsersController < ApplicationController
  before_filter :authenticate
  
  def index
    @users = User.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @user = User.find(params[:id])
    @activities = Activity.where(:user => @user).desc(:created_at).limit(25)
    
    render
  end
  
  def new
    @user = User.new(:account => current_account)
    
    render
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      redirect_to account_users_path, :notice => 'User created successfully!'
    else
      render :new
    end
  end

  def edit
    @user = User.find_by(:id => params[:id])
    
    if @user
      render :edit
    else
      redirect_to account_users_path(:token => current_account.token)
    end
  end
  
  def update
    @user = User.find_by(:id => params[:id])
    
    if @user.update_attributes(params[:user])
      redirect_to edit_account_user_path(@user), :notice => 'User updated successfully!'
    else
      render :edit
    end
  end
  
  def destroy
    @user = User.find_by(:id => params[:id])
    @user.username = "__#{@user.username}"
    @user.email = "__#{@user.email}"
    @user.active = false
    @user.save
    
    redirect_to account_users_path, :notice => 'User deleted successfully!'
  end
end