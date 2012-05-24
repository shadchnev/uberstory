Rails.application.config.middleware.use OmniAuth::Builder do
  raise "Facebook APP_ID and/or APP_SECRET not found" unless ENV['APP_ID'] && ENV['APP_SECRET']
  provider :facebook, ENV['APP_ID'], ENV['APP_SECRET']
end