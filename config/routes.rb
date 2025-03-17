Rails.application.routes.draw do
  devise_for :users
  devise_for :admins, controllers: { sessions: 'admins/sessions' }

  root 'lessons#index'

  resources :lessons, only: %i[index show]

  scope module: :users do
    resources :reservations, only: %i[index show create destroy]
  end

  namespace :admins do
    root 'lessons#index'
    resources :instructors, only: %i[index new create edit update destroy]
    resources :lessons, only: %i[index show new create edit update destroy] do
      resources :lesson_dates, only: %i[show new create edit update destroy], module: 'lessons'
      resources :lesson_questions, only: %i[show new create edit update destroy], module: 'lessons'
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
