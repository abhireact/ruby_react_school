get 'subject_archives/edit'
get 'subject_archives/wing_update/:id' => 'subject_archives#wing_update'
get 'subject_archives/show'
get 'subject_archives/destroy'
get 'subject_archives/create', to: 'subject_archives#create'

get 'subject_archives_list', to: 'subject_archives#archived_subject_list'
post 'subject_archives/:id/unarchive', to: 'subject_archives#subject_unarchive'

get 'subject_archives/index', to: 'subject_archives#index'
get 'subject_archives/getdata', to: 'subject_archives#getdata'
get 'subject_archives/get_subject', to: 'subject_archives#get_subject'
post 'subject_archives/subject_archive_create', to: 'subject_archives#subject_archive_create'

resources :subject_archives