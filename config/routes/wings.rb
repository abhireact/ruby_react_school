get 'wings/edit'

get 'wings/wing_update/:id' => 'wings#wing_update'

get 'wings/show'
post '/', to: 'wings#create', as: :create_wing
# get 'wings/index'
# get 'wings/index', to: 'wings#index'

resources :wings
