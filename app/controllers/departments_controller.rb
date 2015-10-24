class DepartmentsController < ApplicationController
  before_action :set_area
  
  def index    
    @area = Area.find(params[:area_id])
    @departments = Department.where(area_id: params[:area_id])
  end

  def show
    @department = Department.find(params[:id])
    @area = @department.area
    @departments = @area.departments
  end

  private

    def set_area
      @areas = Area.all
    end

end