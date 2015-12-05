class SubventionsController < ApplicationController
  include Sortable

  before_action :authorize_administrators, only: [:new, :create, :edit, :update, :destroy]

  def index
    @subventions = params[:query].present? ? Subvention.search(params[:query]) : Subvention.all
    @subventions = @subventions.reorder(sort_options).page(params[:page])
  end

  def new
    @subvention = Subvention.new
  end

  def create
    @subvention = Subvention.new(subvention_params)
    if @subvention.save
      redirect_to subvention_path(@subvention), notice: I18n.t("subventions.notice.created")
    else
      render :new
    end
  end

  def show
    @subvention = Subvention.find(params[:id])
  end

  def edit
    @subvention = Subvention.find(params[:id])
  end

  def update
    @subvention = Subvention.find(params[:id])
    if @subvention.update(subvention_params)
      redirect_to subvention_path(@subvention), notice: I18n.t("subventions.notice.updated")
    else
      render :edit
    end
  end

  def destroy
    @subvention = Subvention.find(params[:id])
    @subvention.destroy
    redirect_to subventions_path, notice: I18n.t("subventions.notice.deleted")
  end

  private

    def subvention_params
      params.require(:subvention).permit(:recipient, :project, :amount, :year, :kind, :location, :amount_euro_cents)
    end

    def resource_model
      Subvention
    end

    def default_order
      "year desc"
    end

end