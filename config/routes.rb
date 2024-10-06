Rails.application.routes.draw do
  get 'search', to: 'search#searchPage'
  get 'directory', to: 'directory#directory'
  get 'mui', to: 'companies#mui'
  
  resources :companies
  resources :job_posts, defaults: { format: :json }

  root to: 'home#home'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get 'fetch_data', to: 'external_api#fetch_data'
    end
  end  

end
