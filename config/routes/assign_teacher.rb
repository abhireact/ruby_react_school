get 'assign_teacher/index', to: 'assign_teacher#index'

post '/assign_teacher/assign_teacher_update_or_create', to: 'assign_teacher#assign_teacher_update_or_create', as: 'assign_teacher_update_or_create'
resources :assign_teacher