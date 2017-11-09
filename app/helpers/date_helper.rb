module DateHelper

  def format_date(d, format: :default)
    return "" unless d
    I18n.localize(d, format: format)
  end

  def iso_date(d)
    return "" unless d
    d.strftime("%Y-%m-%d")
  end

  def parse_date(date)
    date
  end

end
