Rails.application.routes.draw do
  resources :lesson_dates
  devise_for :admins, controllers: { sessions: 'admins/sessions' }

  namespace :admins do
    root 'lessons#index'
    resources :instructors, only: %i[index new create edit update destroy]
    resources :lessons, only: %i[index show new create edit update destroy] do
      resources :lesson_dates, only: %i[show new create edit update destroy], module: 'lessons'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
