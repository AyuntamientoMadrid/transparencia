class ObjectivesController < ApplicationController
  before_filter :set_objective
  
  def show
  end

  def edit
  end

  private

    def set_objective
      @objective = Objective.find(params[:id])
    end
    
end