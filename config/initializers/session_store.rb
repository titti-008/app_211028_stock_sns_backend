if Rails.env === "production"
  Rails.application.config.session_store :cookie_store, key: '_app_211028_stock_sns_backend',expire_after:2.weeks, domain: :all, tld_length: 2
else
  Rails.application.config.session_store :cookie_store, key: '_rails-backend'
end