get 'castes/edit'
# get 'castes/wing_update/:id' => 'castes#wing_update'
get 'castes/show'
get 'castes/destroy'
get 'castes/index', to: 'castes#index'
get 'castes/getdata', to: 'castes#getdata'
resources :castes