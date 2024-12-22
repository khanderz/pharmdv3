# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  get 'search', to: 'search#search'
  get 'directory', to: 'directory#directory'
  get 'mui', to: 'companies#mui'

  resources :companies
  resources :healthcare_domains, defaults: { format: :json } # When you need full CRUD operations with JSON responses
  resources :company_specialties, defaults: { format: :json }
  resources :cities, defaults: { format: :json }
  resources :countries, defaults: { format: :json }
  resources :states, defaults: { format: :json }
  resources :company_sizes, only: [:index] # When you only need to list records

  resources :job_posts, defaults: { format: :json }
  resources :job_salary_currencies, only: [:index]
  resources :job_salary_intervals, only: :index
  resources :job_settings, defaults: { format: :json }
  resources :job_commitments, defaults: { format: :json }
  resources :benefits, defaults: { format: :json }, only: [:index]
  resources :credentials, defaults: { format: :json }, only: [:index]
  resources :educations, defaults: { format: :json }, only: [:index]
  resources :experiences, defaults: { format: :json }, only: [:index]
  resources :seniorities, defaults: { format: :json }, only: [:index]
  resources :skills, defaults: { format: :json }, only: [:index]

  resources :departments, defaults: { format: :json }
  resources :teams, defaults: { format: :json }
  resources :job_roles, defaults: { format: :json }
  resources :funding_types, only: [:index]

  get 'api/ats_types', to: 'ats_types#index'

  # Health status
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get 'fetch_data', to: 'external_api#fetch_data'
    end
  end
end
