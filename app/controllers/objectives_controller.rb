class ObjectivesController < ApplicationController
  before_action :set_objective
  
  def show
  end

  def edit
  end

  def update
    if @objective.update(objective_params)
      redirect_to objective_path(@objective), notice: "El objetivo se ha actualizado correctamente."
    else
      flash.now[:alert] = "Hubo un error durante la actualización. Revise el formulario."
      render :edit
    end
  end  

  private

    def set_objective
      @objective = Objective.find(params[:id])
    end

    def objective_params
      params.require(:objective).permit(:title, :description, :accomplished)
    end

end