get 'category/edit'
# get 'category/wing_update/:id' => 'category#wing_update'
get 'category/show'
get 'category/destroy'
get 'category/index', to: 'category#caste'
get 'category/getdata', to: 'category#getdata'
resources :category