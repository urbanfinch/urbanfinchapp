class Content::AlbumsController < ApplicationController
  before_filter :authenticate
  
  def index
    @albums = Album.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @album = Album.find(params[:id])
    
    render
  end
  
  def new
    @album = Album.new(:account => current_account)
    
    render
  end
  
  def create
    @album = Album.new(params[:album])
    
    if @album.save
      track_activity @album
      redirect_to content_albums_path, :notice => 'album created successfully!'
    else
      render :new
    end
  end

  def edit
    @album = Album.find_by(:id => params[:id])
    
    if @album
      render :edit
    else
      redirect_to content_albums_path
    end
  end
  
  def update
    @album = Album.find_by(:id => params[:id])
    
    if @album.update_attributes(params[:album])
      track_activity @album
      redirect_to edit_content_album_path(@album), :notice => 'album updated successfully!'
    else
      render :edit
    end
  end
  
  def destroy
    @album = Album.find_by(:id => params[:id])
    track_activity @album
    @album.destroy
    
    redirect_to content_albums_path, :notice => 'album deleted successfully!'
  end
end