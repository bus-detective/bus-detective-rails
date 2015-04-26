Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :stops
    resources :departures
  end

  root to: "index#show"
end
