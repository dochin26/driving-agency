Rails.application.routes.draw do
  # Devise routes for Driver authentication
  devise_for :drivers

  # Root route
  root "dashboard#index"

  # Dashboard
  get "dashboard", to: "dashboard#index"

  # Driving Records
  resources :driving_records do
    collection do
      get :daily_report
      get :export_csv
    end
  end

  # Admin routes
  namespace :admin do
    resources :drivers do
      member do
        get :created
      end
    end
    resources :vehicles
    resources :stores
    resources :customers
    resources :daily_report_settings, only: [ :index, :edit, :update ]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
