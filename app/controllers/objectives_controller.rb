class ObjectivesController < ApplicationController
  
  def show
    @objective = Objective.find(params[:id])
  end

end