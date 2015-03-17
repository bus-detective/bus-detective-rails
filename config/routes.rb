Rails.application.routes.draw do
  namespace :api do
    resources :arrivals
    resources :stops
  end

  root to: "index#show"
end
