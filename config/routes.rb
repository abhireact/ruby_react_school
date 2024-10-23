#   resources :wings
#   # root "home#index"
#    root "sessions#index"
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   # Render dynamic PWA files from app/views/pwa/*
#   get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
#   get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

#   # Defines the root path route ("/")
#   # root "posts#index"
# end

# frozen_string_literal: true

Rails.application.routes.draw do
  get 'classes/index'

  def draw(routes_name)
    instance_eval(Rails.root.join("config/routes/#{routes_name}.rb").read)
  end
  draw :sessions
  draw :wings
  draw :schools
  draw :employees
  draw :classes
  draw :schools
  draw :academics
  draw :dashboards
  draw :addmissions
  draw :mg_admission_settings



  #-------------------------------------#
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
  # Defines the root path route ("/")
  # root "posts#index"
  #-------------------------------------#
  # get 'mg_admission_settings/admission_setting_detail'
  # get 'mg_admission_settings/admission_setting_detail_create'
  # resources :mg_admission_settings
  resources :demos
  resources :dummy

  root to: 'sessions#index'
  # match ':controller(/:action(/:id))', :via => [:get, :post]
end
