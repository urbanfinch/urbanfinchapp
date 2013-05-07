class Content::NavsController < ApplicationController
  before_filter :authenticate
  
  def index
    @navs = Nav.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @nav = Nav.find(params[:id])
    
    render
  end
  
  def new
    @nav = Nav.new(:account => current_account)
    
    render
  end
  
  def create
    @nav = Nav.new(params[:nav])
    
    if @nav.save
      track_activity @nav
      redirect_to content_navs_path, :notice => 'nav created successfully!'
    else
      render :new
    end
  end

  def edit
    @nav = Nav.find_by(:id => params[:id])
    
    if @nav
      render :edit
    else
      redirect_to content_navs_path
    end
  end
  
  def update
    @nav = Nav.find_by(:id => params[:id])
    
    if @nav.update_attributes(params[:nav])
      track_activity @nav
      redirect_to edit_content_nav_path(@nav), :notice => 'nav updated successfully!'
    else
      render :edit
    end
  end
  
  def destroy
    @nav = Nav.find_by(:id => params[:id])
    track_activity @nav
    @nav.destroy
    
    redirect_to content_navs_path, :notice => 'nav deleted successfully!'
  end
end