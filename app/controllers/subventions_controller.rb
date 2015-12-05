class SubventionsController < ApplicationController
  include Sortable

  def index
    @subventions = params[:query].present? ? Subvention.search(params[:query]) : Subvention.all
    @subventions = @subventions.reorder(sort_options).page(params[:page])
  end

  private

    def resource_model
      Subvention
    end

    def default_order
      "year desc"
    end

end