if Rails.env === "production"
  Rails.application.config.session_store :cookie_store, key: '_rails-backend',domain: :all
  Rails.application.config.api_only = false
else
  Rails.application.config.session_store :cookie_store, key: '_rails-backend'
  Rails.application.config.api_only = false
end