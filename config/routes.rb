Rails.application.routes.draw do
  resource :session, only: %i[ new create destroy ]
  # TODO: メール送信APIを使って、パスワードリセット機能を実装する
  # resources :passwords, param: :token, only: %i[ new create edit update ]

  resources :achievements, only: %i[ index new create edit update destroy ] do
    scope module: :achievements do
      resources :challenges, only: %i[ index new create edit update destroy ]
    end
  end
  resources :tasks, only: %i[ index new create edit update destroy] do
    scope module: :tasks do
      resources :time_entries, only: %i[ index create edit update destroy ]
    end
  end
  resources :activities, only: %i[ index new create edit update destroy ] do
    scope module: :activities do
      resources :challenges, only: %i[ index new create edit update destroy ]
    end
  end
  resources :activity_summaries, only: %i[ index new create edit update destroy ]
  resources :tags, only: %i[ index new create edit update destroy ]
  root "home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
