class PagesController < ApplicationController
  before_action :set_page, :only => [:index_by_id, :edit, :update, :show]

  def index
    @pages = Page.roots.arrange_as_array({:order => 'title'})
  end

  def index_by_id
    @pages = []
    @page.path.each do |path_member|
      @pages += path_member.siblings.arrange_as_array({:order => 'title'})
    end
    @pages += @page.children.arrange_as_array({:order => 'title'}) if @page.has_children?
    render :index
  end

  def show
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to index_by_id_page_path(@page), notice: "Se ha añadido contenido correctamente"
    else
      flash.now[:alert] = "Hubo un error al guardar el contenido, revise el formulario"
      render :new
    end
  end

  def update
    if @page.update(page_params)
      redirect_to index_by_id_page_path(@page), notice: "Se modificó el contenido correctamente."
    else
      flash.now[:alert] = "Hubo un error a guardar el contenido. Revise el formulario."
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