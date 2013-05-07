class Content::TestimonialsController < ApplicationController
  before_filter :authenticate
  
  def index
    @testimonials = Testimonial.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @testimonial = Testimonial.find(params[:id])
    
    render
  end
  
  def new
    @testimonial = Testimonial.new(:account => current_account)
    
    render
  end
  
  def create
    @testimonial = Testimonial.new(params[:testimonial])
    
    if @testimonial.save
      track_activity @testimonial
      redirect_to content_testimonials_path, :notice => 'testimonial created successfully!'
    else
      render :new
    end
  end

  def edit
    @testimonial = Testimonial.find_by(:id => params[:id])
    
    if @testimonial
      render :edit
    else
      redirect_to content_testimonials_path
    end
  end
  
  def update
    @testimonial = Testimonial.find_by(:id => params[:id])
    
    if @testimonial.update_attributes(params[:testimonial])
      track_activity @testimonial
      redirect_to edit_content_testimonial_path(@testimonial), :notice => 'testimonial updated successfully!'
    else
      render :edit
    end
  end
  
  def destroy
    @testimonial = Testimonial.find_by(:id => params[:id])
    track_activity @testimonial
    @testimonial.destroy
    
    redirect_to content_testimonials_path, :notice => 'testimonial deleted successfully!'
  end
end