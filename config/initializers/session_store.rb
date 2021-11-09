if Rails.env === "production"
  Rails.application.config.session_store :cookie_store, key: '_rails-backend',domain: :all, tld_length: 2
  Rails.application.config.api_only = false
else
  Rails.application.config.session_store :cookie_store, key: '_rails-backend'
  Rails.application.config.api_only = false
end