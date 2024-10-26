# config/routes/subjects.rb

# Basic subject routes
get 'subjects/edit' => 'subjects#edit'
get 'subjects/wing_update/:id' => 'subjects#wing_update'
get 'subjects/show' => 'subjects#show'
get 'subjects/destroy' => 'subjects#destroy'
get 'subjects/create' => 'subjects#create'
get 'subjects/batch_subject_asso' => 'subjects#batch_subject_asso', as: :batch_subject_asso
get 'subjects/index' => 'subjects#index'
get 'subjects/getdata' => 'subjects#getdata'
get 'subjects/archived_subject_list/subject_archive' => 'subjects#subject_archive'

# Additional routes from resources :subjects
get 'subjects/archived_subject_list' => 'subjects#archived_subject_list'
post 'subjects/subject_archive_create' => 'subjects#subject_archive_create'
get 'subjects/subject_archive' => 'subjects#subject_archive'
get 'subjects/get_subject' => 'subjects#get_subject'
get 'subjects/select_subject/:id' => 'subjects#select_subject'
post 'subjects/batch_subject' => 'subjects#batch_subject'

# Member route for unarchiving a subject
post 'subjects/:id/unarchive' => 'subjects#subject_unarchive', as: :subject_unarchive


resources :subjects