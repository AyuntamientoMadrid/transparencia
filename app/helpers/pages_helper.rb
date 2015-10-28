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

  def page_warning_class(current_page)
    if current_page.present?
      !current_page.has_children? && !current_page.is_page? ? "disabled" : ""
    end
  end  

end