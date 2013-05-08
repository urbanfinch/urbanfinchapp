class Content::EmployeesController < ApplicationController
  before_filter :authenticate
  
  def index
    @employees = Employee.asc(:index)
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @employee = Employee.find(params[:id])
    
    render
  end
  
  def new
    @employee = Employee.new(:account => current_account)
    
    render
  end
  
  def create
    @employee = Employee.new(params[:employee])
    
    if @employee.save
      track_activity @employee
      redirect_to content_employees_path, :notice => 'employee created successfully!'
    else
      render :new
    end
  end

  def edit
    @employee = Employee.find_by(:id => params[:id])
    
    if @employee
      render :edit
    else
      redirect_to content_employees_path
    end
  end
  
  def update
    @employee = Employee.find_by(:id => params[:id])
    
    if @employee.update_attributes(params[:employee])
      track_activity @employee
      redirect_to edit_content_employee_path(@employee), :notice => 'employee updated successfully!'
    else
      render :edit
    end
  end
  
  def destroy
    @employee = Employee.find_by(:id => params[:id])
    track_activity @employee
    @employee.destroy
    
    redirect_to content_employees_path, :notice => 'employee deleted successfully!'
  end
end