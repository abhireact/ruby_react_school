# config/routes/subjects.rb

# Basic subject routes
get 'subjects/edit'
get 'subjects/wing_update/:id' => 'subjects#wing_update'
get 'subjects/show'
get 'subjects/destroy'
get 'subjects/create'
get 'subjects/batch_subject_asso' => 'subjects#batch_subject_asso', as: :batch_subject_asso
get 'subjects/index'
get 'subjects/getdata'
get 'subjects/subject_archive'
# post 'subjects/subject_archive_create', to: 'subjects#subject_archive_create'
# Resource-based routes with archive functionality
resources :subjects do
  collection do
    get 'archived_subject_list'
    post 'subject_archive_create'
    get 'subject_archive'
    get 'get_subject'   
  end
  
  member do
    post 'unarchive', action: 'subject_unarchive'
  end
end