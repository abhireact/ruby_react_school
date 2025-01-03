Rails.application.routes.draw do


 


  def draw(routes_name)
    instance_eval(Rails.root.join("config/routes/#{routes_name}.rb").read)
  end
  draw :upload_excel
  draw :sessions
  draw :wings
  draw :schools
  draw :academics
  draw :category
  draw :student_categories
  draw :subjects
  draw :dashboards
  draw :addmissions
  draw :mg_admission_settings
  draw :upload_excel_set_one
  draw :upload_excel_set_four
  draw :upload_excel_set_three
  draw :upload_excel_set_five
  draw :other_particular
  draw :cbsc_examinations
  draw :classes
  draw :remarks_entry
  draw :mg_employee_departments
  draw :mg_employee_positions
  draw :mg_employee_weekdays
  draw :batches
  draw :attendances
  draw :mg_employee_leave_types
  draw :other_grade
  draw :scholastic_grade
  draw :absent_reason
  draw :exam_report_releases
  draw :other_marks_entry
  draw :bulk_employee_photo_upload
  draw :assign_teacher
  draw :employee_archive
  draw :export_archive_employee

  draw :mg_employees
  draw :experience_certificates

  #-------------------------------------#
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  draw :application
  draw :emp_subjects
  draw :sub_subject
 

  # Reveal health status on /up
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

  resources :mg_greeting_messages
  resources :demos
  resources :dummy
  


  

  root to: 'sessions#index'
end
