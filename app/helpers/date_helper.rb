module DateHelper

  def format_date(d, format: :default)
    return "" unless d
    I18n.localize(d, format: format)
  end

end
