get 'wings/edit'
get 'wings/wing_update/:id' => 'wings#wing_update'
get 'wings/show'
get 'wings/delete'
get 'wings/index', to: 'wings#index'
get 'wings/getdata', to: 'wings#getdata'
resources :wings