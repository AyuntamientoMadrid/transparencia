class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :authenticate_http_basic, if: :http_basic_auth_site?

  add_flash_types :contact_notice, :contact_alert

  private

    def set_locale
      if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
        session[:locale] = params[:locale]
      end

      session[:locale] ||= I18n.default_locale
      I18n.locale = session[:locale]
    end

    def authenticate_http_basic
      authenticate_or_request_with_http_basic do |username, password|
        username == Rails.application.secrets.http_basic_username &&
        password == Rails.application.secrets.http_basic_password
      end
    end

    def http_basic_auth_site?
      Rails.application.secrets.http_basic_auth
    end

end
