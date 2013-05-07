class Content::PostsController < ApplicationController
  before_filter :authenticate
  
  def index
    @posts = Post.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @post = Post.find(params[:id])
    
    render
  end
  
  def new
    @post = Post.new(:account => current_account)
    
    render
  end
  
  def create
    @post = Post.new(params[:post])
    
    if @post.save
      track_activity @post
      redirect_to content_posts_path, :notice => 'post created successfully!'
    else
      render :new
    end
  end

  def edit
    @post = Post.find_by(:id => params[:id])
    
    if @post
      render :edit
    else
      redirect_to content_posts_path
    end
  end
  
  def update
    @post = Post.find_by(:id => params[:id])
    
    if @post.update_attributes(params[:post])
      track_activity @post
      redirect_to edit_content_post_path(@post), :notice => 'post updated successfully!'
    else
      render :edit
    end
  end
  
  def destroy
    @post = Post.find_by(:id => params[:id])
    track_activity @post
    @post.destroy
    
    redirect_to content_posts_path, :notice => 'post deleted successfully!'
  end
end