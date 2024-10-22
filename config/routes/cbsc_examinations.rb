 get '/cbsc_examinations', to:'cbsc_examinations#index'
 post '/cbsc_examinations/create', to: 'cbsc_examinations#create'
 patch '/cbsc_examinations/:id', to: 'cbsc_examinations#edit'
 delete  '/cbsc_examinations/:id', to: 'cbsc_examinations#destroy'
 resources :cbsc_examinations
  