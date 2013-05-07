class Content::ListsController < ApplicationController
  before_filter :authenticate
  
  def index
    @lists = List.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @list = List.find(params[:id])
    
    render
  end
  
  def new
    @list = List.new(:account => current_account)
    
    render
  end
  
  def create
    @list = List.new(params[:list])
    
    if @list.save
      track_activity @list
      redirect_to content_lists_path, :notice => 'list created successfully!'
    else
      render :new
    end
  end

  def edit
    @list = List.find_by(:id => params[:id])
    
    if @list
      render :edit
    else
      redirect_to content_lists_path
    end
  end
  
  def update
    @list = List.find_by(:id => params[:id])
    
    if @list.update_attributes(params[:list])
      track_activity @list
      redirect_to edit_content_list_path(@list), :notice => 'list updated successfully!'
    else
      render :edit
    end
  end
  
  def destroy
    @list = List.find_by(:id => params[:id])
    track_activity @list
    @list.destroy
    
    redirect_to content_lists_path, :notice => 'list deleted successfully!'
  end
end