# Internationalization configuration
Rails.application.config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

# Available locales for the application
Rails.application.config.i18n.available_locales = [:en, :"zh-CN"]

# Default locale
Rails.application.config.i18n.default_locale = :en

# Fallback to default locale if translation is missing
Rails.application.config.i18n.fallbacks = [:en]

# Raise errors in development for missing translations
if Rails.env.development?
  Rails.application.config.i18n.raise_on_missing_translations = false
end
