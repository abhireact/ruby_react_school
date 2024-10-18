get 'subject_archives/edit'
get 'subject_archives/wing_update/:id' => 'subject_archives#wing_update'
get 'subject_archives/show'
get 'subject_archives/destroy'
get 'subject_archives/create', to: 'subject_archives#create'

get 'subject_archives/index', to: 'subject_archives#index'
get 'subject_archives/getdata', to: 'subject_archives#getdata'
resources :subject_archives