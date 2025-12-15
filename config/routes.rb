Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "ebooks#index"
  resources :ebooks do
    member do
      get "preview"
      post "update_status"
      post "purchase"
    end
  end
  resources :authors
  resources :users, except: [ :new ] do
    post "update_status", on: :member
  end
  get "sign_up", to: "users#new"

  get "sign_in", to: "sessions#new"
  post "create_session", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"

  get "forgot_password", to: "passwords#new"
  post "send_forgot_password_email", to: "passwords#create"
  get "new_password/:token", to: "passwords#edit", as: :new_password
  put "update_password/:token", to: "passwords#update", as: :update_password
  get "expired_password", to: "passwords#expired_password"
  put "update_expired_password", to: "passwords#update_expired_password"
end
