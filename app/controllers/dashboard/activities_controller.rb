class Dashboard::ActivitiesController < ApplicationController
  before_filter :authenticate
  
  def index
    @activities = Activity.all
    
    respond_to do |format|
      format.html
    end
  end
end