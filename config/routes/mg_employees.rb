get 'mg_employees/index', to: 'mg_employees#index'



post 'mg_employees/create_employee', to: 'mg_employees#create_employee', as: 'create_employee'

patch 'mg_employees/update_employee/:id', to: 'mg_employees#update_employee', as: 'update_employee'

get 'mg_employees/get_employee/:id', to: 'mg_employees#get_employee', as: 'get_employee'
get 'mg_employees/get_all_employees', to: 'mg_employees#get_all_employees', as: 'get_all_employees'

delete 'mg_employees/delete_employee/:id', to: 'mg_employees#delete_employee', as: 'delete_employee'


  


resources :mg_employees