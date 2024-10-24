get 'academics/index'
post '/academic_years', to: 'academics#create'
patch '/academic_years/:id', to: 'academics#update'
delete '/academic_years/:id', to: 'academics#destroy'
resources :academics
