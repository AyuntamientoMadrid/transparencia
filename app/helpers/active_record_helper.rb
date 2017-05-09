module ActiveRecordHelper
  def active_record_field(model_instance, field_name)
    [
      content_tag(:strong,
                  model_instance.class.human_attribute_name(field_name)),
      ': ',
      model_instance.send(field_name)
    ].join.html_safe
  end
end
