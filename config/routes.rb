Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :agencies, only: [:show, :index] do
      resources :departures, only: :index
      resources :shapes, only: :show
      resources :stops, only: [:index, :show]
      resources :trips, only: [:index]
    end
  end

  root to: "index#show"
  get "*path", to: "index#show"
end
