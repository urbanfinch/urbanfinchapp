class Dashboard::MessagesController < ApplicationController
  before_filter :authenticate
  
  def index
    @messages = Message.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @message = Message.find_by(:id => params[:id])
  end
  
  def new
    @message = Message.new(:account => current_account, :user => current_user)
    
    render
  end
  
  def create
    @message = Message.new(params[:message])
    
    if @message.save
      track_activity @message
      redirect_to dashboard_messages_path, :notice => 'Message created successfully!'
    else
      render :new
    end
  end

  def edit
    @message = Message.find_by(:id => params[:id])
    
    if @message && @message.user_id == current_user.id
      render :edit
    else
      redirect_to dashboard_messages_path
    end
  end
  
  def comment
    @message = Message.find_by(:id => params[:id])
    
    if @message.update_attributes(params[:message])
      track_activity @message
      redirect_to dashboard_message_path(@message)
    else
      render :show
    end
  end
  
  def update
    @message = Message.find_by(:id => params[:id])
    
    if @message.update_attributes(params[:message])
      track_activity @message
      redirect_to edit_dashboard_message_path(@message), :notice => 'Message updated successfully!'
    else
      render :edit
    end
  end
  
  def destroy
    @message = Message.find_by(:id => params[:id])
    
    if @message && @message.user_id == current_user.id
      @message.active = false
      @message.save
      
      track_activity @customer
      
      redirect_to dashboard_messages_path, :notice => 'Message deleted successfully!'
      
    else
      redirect_to dashboard_messages_path
    end
  end
end