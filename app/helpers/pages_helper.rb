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

end