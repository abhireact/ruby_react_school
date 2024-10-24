get 'batches/new'
# get 'batches/manage' => 'batches#manage' , as: :manage
get 'batches/manage/:id' => 'batches#manage' , as: :manage
post 'batches/create'
post 'batches/:id/edit' => 'batches#edit' , as: :batch_edit
get 'batches/check_validate/' => 'batches#check_validate' , as: :check_validate
get 'batches/batcheList'

#react routes
get '/batches/batcheList/:id', to: 'batches#batcheList'
post '/batches/create', to: 'batches#create'
delete  '/batches/:id', to: 'batches#delete'

resources :batches