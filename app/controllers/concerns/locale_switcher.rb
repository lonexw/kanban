# Concern for handling locale switching in controllers
#
# This allows users to set their preferred locale via:
# 1. URL parameter (?locale=zh-CN)
# 2. Session storage (persists across requests)
# 3. Accept-Language header (browser preference)
# 4. Falls back to default locale
#
module LocaleSwitcher
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale
    helper_method :current_locale, :locale_label
  end

  private

  def switch_locale(&action)
    locale = resolve_preferred_locale
    I18n.with_locale(locale, &action)
  end

  def resolve_preferred_locale
    locale_from_params || locale_from_session || locale_from_header || I18n.default_locale
  end

  def locale_from_params
    locale = params[:locale]
    if locale && valid_locale?(locale)
      session[:locale] = locale
      locale
    end
  end

  def locale_from_session
    locale = session[:locale]
    valid_locale?(locale) ? locale : nil
  end

  def locale_from_header
    return nil unless request.env["HTTP_ACCEPT_LANGUAGE"]
    
    accepted_languages = request.env["HTTP_ACCEPT_LANGUAGE"]
      .split(",")
      .map { |lang| lang.split(";").first.strip }
    
    accepted_languages.find { |lang| valid_locale?(lang) }
  end

  def valid_locale?(locale)
    locale && I18n.available_locales.include?(locale.to_sym)
  end

  # Helper methods for views
  def current_locale
    I18n.locale
  end

  def locale_label(locale = nil)
    locale ||= I18n.locale
    t("locales.#{locale}", default: locale.to_s.upcase)
  end

  # Helper method for generating URLs with locale parameter
  def default_url_options
    { locale: current_locale }
  end
end
