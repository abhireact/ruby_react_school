#   get 'schools/ajax_request_for_unique_subdomain_name'
#  get 'schools/custom_fields'
#   get 'schools/custom_fields_edit/:id' =>'schools#custom_fields_edit'
#   patch "schools/custom_fields_update/:id" => "schools#custom_fields_update"
#  get 'schools/custum_fields_delete/:id' => 'schools#custum_fields_delete'
#  get 'schools/custom_index'
#   get 'schools/custom_create'
#   post 'schools/custom_create'
#   get 'schools/custom_new' => 'schools#custom_new', as: :school_custom_new
#   post 'schools/custom_new'
#    # get 'schools/custom_fields_update'
#   # post 'schools/custom_fields_update'
 patch '/schools/:id', to: 'schools#update'
  get 'schools/academic'
  post '/academic_years', to: 'schools#create'
  patch '/academic_years/:id', to: 'schools#update'
  delete '/academic_years/:id', to: 'schools#destroy'
   resources :schools
