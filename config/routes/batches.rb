
get '/batches/batcheList/:id', to: 'batches#batcheList'
 post '/batches/create', to: 'batches#create'
delete  '/batches/:id', to: 'batches#delete'

resources :batches