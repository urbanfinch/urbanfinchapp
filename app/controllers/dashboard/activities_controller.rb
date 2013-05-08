class Dashboard::ActivitiesController < ApplicationController
  before_filter :authenticate
  
  def index
    @activities = Activity.desc(:created_at).limit(15)
    
    respond_to do |format|
      format.html
    end
  end
end