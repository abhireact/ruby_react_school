<<<<<<< HEAD
get 'classes/check'
get 'classes/modeltest'
get 'classes/new'
get 'classes/index'
post 'classes/edit/:id'=> 'classes#edit'

#-----------------------------upper one for testing-------------------------
get 'classes/grouped_batches/:id'=>'classes#grouped_batches'
get 'classes/create_batch_group'
get 'classes/addBatch'
resources :classes







=======
delete 'classes/:id', to: 'classes#delete'

get 'classes/update/:id' => 'classes#employee_update'

get 'classes/index'

resources :classes
>>>>>>> main
