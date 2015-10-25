module PagesHelper

  def pages_options_for_select
    pages = Page.where(parent_id: nil).order(:title)
    options = []
    pages.each do |page|      
      options = options(page, options)
    end   
    options
  end

  def options(page, options)
    options << ["#{prefix(page)}#{page.title}", page.id]
    return options if page.pages.empty?
    page.pages.each do |child|   
      options = options(child, options)
    end
    options
  end

  def prefix(page)
    prefix = ""
    (page.level - 1).times do |level|
      prefix += "--"
    end
    prefix
  end

end