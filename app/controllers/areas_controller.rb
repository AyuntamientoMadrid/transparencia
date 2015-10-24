class AreasController < ApplicationController
  
  def index
    @areas = Area.all
  end

end