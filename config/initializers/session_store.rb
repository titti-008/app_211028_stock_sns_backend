if Rails.env === "production"
  
  Rails.application.config.session_store :cookie_store, key: '_rails-backend',expire_after:2.weeks, domain: "app-211028-react-frontend.herokuapp.com", tld_length: 2
else
  Rails.application.config.session_store :cookie_store, key: '_rails-backend'
end