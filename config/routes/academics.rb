get 'schools/academic'
post '/academic_years', to: 'schools#create'
patch '/academic_years/:id', to: 'schools#update'
delete '/academic_years/:id', to: 'schools#destroy'
resources :academics
