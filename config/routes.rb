Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :arrivals
    resources :stops
  end

  root to: "index#show"
end
