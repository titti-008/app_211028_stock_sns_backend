if Rails.env === "production"
  Rails.application.config.session_store :cookie_store, key: '_app-211028-react-frontend',domain: :all
else
  Rails.application.config.session_store :cookie_store, key: '_rails-backend'
end