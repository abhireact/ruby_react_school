post 'mg_employee_departments/delete'
get 'mg_employee_departments/new'
# react routes
get 'mg_employee_departments', to:'mg_employee_departments#index'
post '/mg_employee_departments/create', to: 'mg_employee_departments#create'
patch '/mg_employee_departments/:id', to: 'mg_employee_departments#update'
delete  '/mg_employee_departments/:id', to: 'mg_employee_departments#delete'
get 'mg_employee_departments/show_departments', to: 'mg_employee_departments#show_departments', as:'show_departments'


resources :mg_employee_departments
