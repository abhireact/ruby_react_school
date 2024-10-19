Rails.application.routes.draw do
  get 'classes/index'

  def draw(routes_name)
    instance_eval(Rails.root.join("config/routes/#{routes_name}.rb").read)
  end

  draw :sessions
  draw :wings
  draw :schools
  draw :academics
  draw :houses
  draw :sports
  draw :castes
  draw :category
  draw :student_hobbies
  draw :subjects
  draw :dashboards
  draw :subject_archives
  draw :classes
  draw :application

  # Reveal health status on /up
  get 'up' => 'rails/health#show', as: :rails_health_check
  
  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  resources :demos
  resources :dummy

  root to: 'sessions#index'
end
