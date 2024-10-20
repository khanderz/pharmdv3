Rails.application.routes.draw do
  root to: 'search#searchPage'

  get 'directory', to: 'directory#directory'
  get 'mui', to: 'companies#mui'

  resources :companies
  resources :job_posts, defaults: { format: :json }

  # Health status
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get 'fetch_data', to: 'external_api#fetch_data'
    end
  end
end
