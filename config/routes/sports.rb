get 'sports/edit'
# get 'sports/wing_update/:id' => 'sports#wing_update'
get 'sports/show'
get 'sports/destroy'
get 'sports/index', to: 'sports#index'
get 'sports/getdata', to: 'sports#getdata'
resources :sports