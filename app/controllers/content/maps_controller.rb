class Content::MapsController < ApplicationController
  before_filter :authenticate
  
  def index
    @maps = Map.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @map = Map.find(params[:id])
    
    render
  end
  
  def new
    @map = Map.new(:account => current_account)
    
    render
  end
  
  def create
    @map = Map.new(params[:map])
    
    if @map.save
      track_activity @map
      redirect_to content_maps_path, :notice => 'map created successfully!'
    else
      render :new
    end
  end

  def edit
    @map = Map.find_by(:id => params[:id])
    
    if @map
      render :edit
    else
      redirect_to content_maps_path
    end
  end
  
  def update
    @map = Map.find_by(:id => params[:id])
    
    if @map.update_attributes(params[:map])
      track_activity @map
      redirect_to edit_content_map_path(@map), :notice => 'map updated successfully!'
    else
      render :edit
    end
  end
  
  def destroy
    @map = Map.find_by(:id => params[:id])
    track_activity @map
    @map.destroy
    
    redirect_to content_maps_path, :notice => 'map deleted successfully!'
  end
end