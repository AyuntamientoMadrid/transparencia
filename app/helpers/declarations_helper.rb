include ActionView::Helpers::TranslationHelper

module DeclarationsHelper

  PERIODS_START_YEAR = 2016

  def periods_list
    initial = { initial: t('initial') }
    years = Hash[(PERIODS_START_YEAR..Date.current.year + 1).map { |year| [year, year] }]
    final = { final: t('final') }
    initial.merge(years).merge(final)
  end

  def declaration_name(declaration, i18n_namespace:)
    if declaration.initial?
      t("#{i18n_namespace}.initial", year: declaration.declaration_date.year)
    elsif declaration.final?
      t("#{i18n_namespace}.final", year: declaration.declaration_date.year)
    else
      t("#{i18n_namespace}.yearly", year: declaration.declaration_date.year)
    end
  end
end
