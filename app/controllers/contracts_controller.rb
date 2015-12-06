class ContractsController < ApplicationController
  include Sortable

  before_action :authorize_administrators, only: [:new, :create, :edit, :update, :destroy]

  def index
    @contracts = params[:query].present? ? Contract.search(params[:query]) : Contract.all
    @contracts = @contracts.reorder(sort_options).page(params[:page])
  end

  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(contract_params)
    if @contract.save
      redirect_to contract_path(@contract), notice: I18n.t("contracts.notice.created")
    else
      render :new
    end
  end

  def show
    @contract = Contract.find(params[:id])
  end

  def edit
    @contract = Contract.find(params[:id])
  end

  def update
    @contract = Contract.find(params[:id])
    if @contract.update(contract_params)
      redirect_to contract_path(@contract), notice: I18n.t("contracts.notice.updated")
    else
      render :edit
    end
  end

  def destroy
    @contract = Contract.find(params[:id])
    @contract.destroy
    redirect_to contracts_path, notice: I18n.t("contracts.notice.deleted")
  end

  private

    def contract_params
      params.require(:contract).permit(:center, :organism, :contract_number,
                                       :document_number, :description, :kind,
                                       :award_procedure, :article, :article_section,
                                       :award_criteria, :budget_amount_cents,
                                       :award_amount_cents, :term, :awarded_at,
                                       :recipient, :recipient_document_number,
                                       :formalized_at, :framework_agreement,
                                       :zero_cost_revenue)
    end

    def resource_model
      Contract
    end

    def default_order
      "awarded_at desc"
    end

end