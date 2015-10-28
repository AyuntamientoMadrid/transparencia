module PagesHelper

  def page_title_helper(page)
    page.depth == 0 ? "¿Qué buscas?" : page.parent.title
  end

  def page_column_helper(depth)
    if depth == 0
      "column_left"
    elsif depth == 1
      "column_center"
    else
      "column_right"
    end
  end

  def page_active_class(current_page, page)
    if current_page.present?
      ( page == current_page || current_page.ancestors.include?(page) ) ? "active" : ""
    end
  end

  def page_disabled_class(page)
    !page.has_children? && !page.is_page? ? "disabled" : ""
  end  

  def link_to_page(page, &block)
    options = {}
    options[:target] = page.link? ? "_blank" : "_self"
    options[:class] = "#{page_active_class(@page, page)} #{page_disabled_class(page)}"
    link = page.link? ? page.link : page_path(page)
    link_to link, options do
      block.call
    end
  end

  def empty_sections_placeholders(pages)
    content = ""
    depths = pages.collect{|p| p.depth }
    (0..2).each do |depth|
      unless depths.include?(depth)
        content +="<div class=\"large-#{depth + 3} columns\">
          <div class=\"#{page_column_helper(depth)}\">
          </div>
        </div>"
      end
    end
    content.html_safe
  end

end