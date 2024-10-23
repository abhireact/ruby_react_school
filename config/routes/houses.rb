get 'houses/edit'
get 'houses/wing_update/:id' => 'houses#wing_update'
get 'houses/show'
get 'houses/destroy'
get 'houses/index', to: 'houses#index'
get 'houses/getdata', to: 'houses#getdata'
resources :houses