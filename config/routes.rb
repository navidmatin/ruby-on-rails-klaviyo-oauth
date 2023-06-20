Rails.application.routes.draw do
  root "home#index"
  get 'home/index'
  get "/campaigns", to: "home#campaigns"
  get "/oauth", to: "o_auth#index"
  get "/oauth/authenticate_klaviyo", to: "o_auth#authenticate_klaviyo"
  get "/oauth/redirect", to: "o_auth#redirect"
end
