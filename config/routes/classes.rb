 get 'classes', to:'classes#index'
 post '/classes/create', to: 'classes#create'
 patch '/classes/:id', to: 'classes#edit'
 delete  '/classes/:id', to: 'classes#delete'
 resources :classes
