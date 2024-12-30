get 'experience_certificates/index', to: 'experience_certificates#index'

get 'experience_certificates/issue_certificates/:id', to: 'experience_certificates#issue_certificates'

get 'experience_certificates/show_employee_certificate/:id', to: 'experience_certificates#show_employee_certificate'

post 'experience_certificates/create_experience_certificate', to: 'experience_certificates#create_experience_certificate'

patch 'experience_certificates/update_experience_certificate/:id', to: 'experience_certificates#update_experience_certificate'

patch 'experience_certificates/track_and_generate_certificate/:id', to: 'experience_certificates#track_and_generate_certificate'

resources :experience_certificates