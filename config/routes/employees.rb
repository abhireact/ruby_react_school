get 'employees/delete'

get 'employees/update/:id' => 'employees#employee_update'



get "employees/index"
get "employees/create"
post '/', to: 'employee#create', as: :create_employee
resources :employees
