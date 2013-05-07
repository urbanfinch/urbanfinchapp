class Content::BlurbsController < ApplicationController
  before_filter :authenticate
  
  def index
    @blurbs = Blurb.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @blurb = Blurb.find(params[:id])
    
    render
  end
  
  def new
    @blurb = Blurb.new(:account => current_account)
    
    render
  end
  
  def create
    @blurb = Blurb.new(params[:blurb])
    
    if @blurb.save
      track_activity @blurb
      redirect_to content_blurbs_path, :notice => 'blurb created successfully!'
    else
      render :new
    end
  end

  def edit
    @blurb = Blurb.find_by(:id => params[:id])
    
    if @blurb
      render :edit
    else
      redirect_to content_blurbs_path
    end
  end
  
  def update
    @blurb = Blurb.find_by(:id => params[:id])
    
    if @blurb.update_attributes(params[:blurb])
      track_activity @blurb
      redirect_to edit_content_blurb_path(@blurb), :notice => 'blurb updated successfully!'
    else
      render :edit
    end
  end
  
  def destroy
    @blurb = Blurb.find_by(:id => params[:id])
    track_activity @blurb
    @blurb.destroy
    
    redirect_to content_blurbs_path, :notice => 'blurb deleted successfully!'
  end
end