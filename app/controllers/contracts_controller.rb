class ContractsController < ApplicationController
  include Sortable

  def index
    @contracts = params[:query].present? ? Contract.search(params[:query]) : Contract.all
    @contracts = @contracts.reorder(sort_options).page(params[:page])
  end

  private

    def resource_model
      Contract
    end

    def default_order
      "awarded_at desc"
    end

end