include ActionView::Helpers::TranslationHelper

module DeclarationsHelper

  PERIODS_START_YEAR = 2016

  def periods_list
    initial = { initial: t('initial') }
    years = Hash[(PERIODS_START_YEAR..Date.current.year + 1).map { |year| [year, year] }]
    final = { final: t('final') }
    initial.merge(years).merge(final)
  end

end
