class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :authenticate_http_basic, if: :http_basic_auth_site?
  before_action :authorize

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

    def authorize
      return true unless only_full_features?

      unless %w(home people pages).include?(controller_name)
        raise ActionController::RoutingError.new('Not Found')
      end
    end

    def only_full_features?
      Rails.application.secrets.only_full_features
    end

    def authorize_administrators
      raise ActionController::RoutingError.new('Not Found') unless current_administrator.present?
    end

end
