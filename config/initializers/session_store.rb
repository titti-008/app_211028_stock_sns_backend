if Rails.env === "production"
  
  Rails.application.config.session_store :cookie_store, key: '_rails-backend',domain: ".herokuapp.com"
else
  Rails.application.config.session_store :cookie_store, key: '_rails-backend'
end