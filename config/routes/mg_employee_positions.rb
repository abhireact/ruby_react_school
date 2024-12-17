post 'mg_employee_positions/delete'
get 'mg_employee_positions/new'
# react routes
get 'mg_employee_positions', to:'mg_employee_positions#index'
post '/mg_employee_positions/create', to: 'mg_employee_positions#create'
patch '/mg_employee_positions/:id', to: 'mg_employee_positions#update'
delete  '/mg_employee_positions/:id', to: 'mg_employee_positions#delete'
get 'mg_employee_positions/show_positions', to: 'mg_employee_positions#show_positions', as:'show_positions'



resources :mg_employee_positions