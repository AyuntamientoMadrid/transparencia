class ContractsController < ApplicationController

  def index
    @contracts = params[:query].present? ? Contract.search(params[:query]) : Contract.all
    @contracts = @contracts.reorder(awarded_at: :desc).page(params[:page])
  end

end