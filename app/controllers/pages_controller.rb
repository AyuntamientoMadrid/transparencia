class PagesController < ApplicationController
  before_action :set_selected

  def index
    @pages_section1 = Page.where(parent_id: nil)
    @pages_section2 = []
    @pages_section3 = []

    if @selected.present? && @selected.level == 1
      @pages_section2 = Page.where(parent_id: @selected.id)
    end

    if @selected.present? && @selected.level == 2
      @pages_section2 = Page.where(parent_id: @selected.parent.id)
      @pages_section3 = Page.where(parent_id: @selected.id)
    end
  end

  def show
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
  end

  def update
  end

  private

  def set_selected
    @selected = Page.find(params[:selected]) if params[:selected].present?
  end

end