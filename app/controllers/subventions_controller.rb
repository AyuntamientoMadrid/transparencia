class SubventionsController < ApplicationController
  include Sortable

  def index
    @subventions = params[:query].present? ? Subvention.search(params[:query]) : Subvention.all
    @subventions = @subventions.reorder(sort_options).page(params[:page])
  end

end