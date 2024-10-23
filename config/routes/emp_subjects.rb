get 'emp_subjects/edit'
get 'emp_subjects/wing_update/:id' => 'emp_subjects#wing_update'
get 'emp_subjects/show'
get 'emp_subjects/destroy'
get 'emp_subjects/create', to: 'emp_subjects#create'

get 'select_subject_emp/:id', to: 'emp_subjects#select_subject_emp'
get 'emp_subjects/get_subject_batch_id'

post 'emp_subjects/:id/unarchive', to: 'emp_subjects#subject_unarchive'

get 'emp_subjects/index', to: 'emp_subjects#index'
get 'emp_subjects/getdata', to: 'emp_subjects#getdata'
get 'emp_subjects/get_subject', to: 'emp_subjects#get_subject_batch_id'

post 'emp_subjects/subject_archive_create', to: 'emp_subjects#emp_subject'


resources :emp_subjects