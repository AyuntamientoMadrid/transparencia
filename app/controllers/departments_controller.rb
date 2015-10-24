class DepartmentsController < ApplicationController
  
  def index
    @areas = Area.all
  end

  def show
    @department = Department.find(params[:id])
  end

end