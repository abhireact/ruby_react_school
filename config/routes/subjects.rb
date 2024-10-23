get 'subjects/edit'
get 'subjects/wing_update/:id' => 'subjects#wing_update'
get 'subjects/show'
get 'subjects/destroy'
get 'subjects/create', to: 'subjects#create'
# get 'subjects/batch_subject_asso' => 'subjects#batch_subject_asso', as: :batch_subject_asso
get 'subjects/batch_subject_asso' => 'subjects#batch_subject_asso', as: :batch_subject_asso
get 'subjects/index', to: 'subjects#index'
get 'subjects/getdata', to: 'subjects#getdata'
resources :subjects

resources :batches do
  member do
    get 'manage_subjects', action: 'select_subject' # This would create manage_subjects_batch_path instead
  end
end
