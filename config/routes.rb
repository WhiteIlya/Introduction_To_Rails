Rails.application.routes.draw do
  root "home#index"
  get "home/about"

  namespace :api do
    resources :friends, except: [ :new, :edit ]
    post "/users/create", to: "users#create"
    patch "/profile", to: "users#update"
    get "/profile", to: "users#me"
    post "/auth/login", to: "auth#login"
  end




  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
