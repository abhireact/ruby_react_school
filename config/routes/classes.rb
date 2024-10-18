delete 'classes/:id', to: 'classes#delete'

get 'classes/update/:id' => 'classes#employee_update'

get 'classes/index'

resources :classes
