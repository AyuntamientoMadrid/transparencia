module ApplicationHelper
  def active_class(current_object, object)
    current_object.present? && current_object == object ? "active" : ""    
  end
end