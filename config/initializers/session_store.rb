if Rails.env === "production"
  Rails.application.config.session_store :cookie_store, key: '_rails-backend',domain: ENV["FRONT_END_DOMAIN"]
else
  Rails.application.config.session_store :cookie_store, key: '_rails-backend'
end