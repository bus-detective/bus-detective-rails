Rails.application.routes.draw do
  namespace :api do
    resources :arrivals
  end
end
