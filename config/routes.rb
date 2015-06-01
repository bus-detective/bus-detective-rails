Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :stops
    resources :trips
    resources :departures
  end

  root to: "index#show"
  get "*path", to: "index#show"
end
