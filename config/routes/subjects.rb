get 'subjects/edit'
get 'subjects/wing_update/:id' => 'subjects#wing_update'
get 'subjects/show'
get 'subjects/destroy'
get 'subjects/index', to: 'subjects#index'
get 'subjects/getdata', to: 'subjects#getdata'
resources :subjects