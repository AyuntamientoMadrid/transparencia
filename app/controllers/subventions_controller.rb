class SubventionsController < ApplicationController

  def index
    @subventions = Subvention.all.order(year: :desc).page(params[:page])
  end

end