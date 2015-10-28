module ApplicationHelper
  def active_class(current_object, object)
    object == current_object ? "active" : ""
  end
end