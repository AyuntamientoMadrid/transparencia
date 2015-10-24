class DepartmentsController < ApplicationController
  
  def index
    @areas = Area.all
    @area = Area.find(params[:area_id])
    @departments = Department.where(area_id: params[:area_id])
  end

  def show
    @department = Department.find(params[:id])
  end

end