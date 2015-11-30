module CacheKeysHelper

  def locale_key
    @locale_key ||= I18n.locale
  end

end