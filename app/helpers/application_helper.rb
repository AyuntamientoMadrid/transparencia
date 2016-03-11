module ApplicationHelper

  def active_class(current_object, object)
    object == current_object ? "active" : ""
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def boolean_to_text(bool)
    bool ? t("booleans.t") : t("booleans.f")
  end

  # if current path is /people current_path_with_query_params(foo: 'bar') returns /people?foo=bar
  # notice: if query_params have a param which also exist in current path, it "overrides" (query_params is merged last)
  def current_path_with_query_params(query_parameters)
    url_for(request.query_parameters.merge(query_parameters))
  end

end
