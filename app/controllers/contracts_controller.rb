class ContractsController < ApplicationController

  def index
    @contracts = Contract.all.order(awarded_at: :desc).page(params[:page])
  end

end