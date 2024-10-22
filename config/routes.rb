Rails.application.routes.draw do
  root to: 'home#index'

  get 'directory', to: 'directory#directory'
  get 'mui', to: 'companies#mui'

  resources :companies
  resources :job_posts, defaults: { format: :json }
  resources :departments, defaults: { format: :json }
  resources :teams, defaults: { format: :json }
  resources :job_roles, defaults: { format: :json }
  resources :cities, defaults: { format: :json }
  resources :countries, defaults: { format: :json }
  resources :states, defaults: { format: :json }
  resources :healthcare_domains, defaults: { format: :json }
  resources :company_specialties, defaults: { format: :json }
  resources :job_settings, defaults: { format: :json }
  resources :job_commitments, defaults: { format: :json }

  # Health status
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get 'fetch_data', to: 'external_api#fetch_data'
    end
  end
end
