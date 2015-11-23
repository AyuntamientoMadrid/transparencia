class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  add_flash_types :contact_notice, :contact_alert

  private

    def set_locale
      if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
        session[:locale] = params[:locale]
      end

      session[:locale] ||= I18n.default_locale
      I18n.locale = session[:locale]
    end
end
