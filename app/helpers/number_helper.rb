module NumberHelper
  def format_amount(amount)
    return nil if amount.blank?
    number_with_delimiter(amount, I18n.t('amount.format')).gsub(/,0$/, '')
  end
end
