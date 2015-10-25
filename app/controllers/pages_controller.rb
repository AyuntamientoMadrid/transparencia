class PagesController < ApplicationController
  before_action :set_selected
  before_action :set_page, :only => [:edit, :update]

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
    page = Page.new(page_params)
    if page.save
      redirect_to pages_path(selected: @page.parent), notice: "Se ha añadido contenido correctamente"
    else
      flash.now[:alert] = "Hubo un error al guardar el contenido, revise el formulario"
      render :new
    end
  end

  def update
    if @page.update(page_params)
      redirect_to pages_path(selected: @page.parent), notice: "Se modificó el contenido correctamente."
    else
      flash.now[:alert] = "Hubo un error a guardar el contenido. Revise el formulario."
      render :edit
    end
  end

  private

    def set_selected
      @selected = Page.find(params[:selected]) if params[:selected].present?
    end

    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :subtitle, :content, :side_content, :link, :parent_id)
    end

end