get 'classes/check'
get 'classes/modeltest'
get 'classes/new'
get 'classes/index'
post 'classes/edit/:id'=> 'classes#edit'
get 'classes/grouped_batches/:id'=>'classes#grouped_batches'
get 'classes/create_batch_group'
get 'classes/addBatch'
 # react routes
get 'classes', to:'classes#index'
post '/classes/create', to: 'classes#create'
patch '/classes/:id', to: 'classes#edit'
delete  '/classes/:id', to: 'classes#delete'
resources :classes
