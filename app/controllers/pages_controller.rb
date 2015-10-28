class PagesController < ApplicationController
  before_action :set_page, :only => [:edit, :update, :show]

  def index
    @pages_path = [Page.roots.first]
  end

  def show
    if @page.has_children?
      @pages_path = @page.path
      @pages_path << @page.children.first if @page.depth <=1
      render :index 
    end
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to page_path(@page.depth < 3 ? @page : @page.parent ), notice: "Se ha añadido una nueva página correctamente."
    else
      flash.now[:alert] = "Hubo un error al guardar la página, revise el formulario."
      render :new
    end
  end

  def update
    if @page.update(page_params)
      redirect_to page_path(@page), notice: "Se ha modificado la página correctamente."
    else
      flash.now[:alert] = "Hubo un error a guardar la página. Revise el formulario."
      render :edit
    end
  end

  private

    def page_params
      params.require(:page).permit(:title, :subtitle, :content, :link, :parent_id)
    end

    def set_page
      @page = Page.find(params[:id]) if params[:id].present?
    end

end