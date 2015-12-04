class SubventionsController < ApplicationController

  def index
    @subventions = params[:query].present? ? Subvention.search(params[:query]) : Subvention.all
    @subventions = @subventions.reorder(year: :desc).page(params[:page])
  end

end