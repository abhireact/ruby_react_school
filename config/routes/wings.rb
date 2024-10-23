get 'wings/edit'
get 'wings/wing_update/:id' => 'wings#wing_update'
get 'wings/show'
get 'wings/index', to: 'wings#index'
resources :wings