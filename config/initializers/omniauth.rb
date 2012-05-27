Rails.application.config.middleware.use OmniAuth::Builder do
  # raise "Facebook APP_ID and/or APP_SECRET not found" unless Rails.configuration.facebook_app_id && Rails.configuration.facebook_app_secret
  provider :facebook, Rails.configuration.facebook_app_id, Rails.configuration.facebook_app_secret
end