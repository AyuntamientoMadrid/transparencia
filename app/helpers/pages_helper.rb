module PagesHelper

  def title_helper(current_page, depth)
    title = ""
    if current_page.present?
      (current_page.ancestors << current_page).each do |ancestor|
        title = ancestor.title if ancestor.depth == depth
      end
    end
    title
  end

  def page_active_class(current_page, page)
    if current_page.present?
      ( page == current_page || current_page.ancestors.include?(page) ) ? "active" : ""
    end
  end

  def page_warning_class(page)
    !page.has_children? && !page.is_page? ? "disabled" : ""
  end  

  def link_to_page(page, &block)
    options = {}
    options[:target] = page.link? ? "_blank" : "_self"
    options[:class] = "#{page_active_class(@page, page)} #{page_warning_class(page)}"
    link = page.link? ? page.link : page_path(page)
    link_to link, options do
      block.call
    end
  end

end