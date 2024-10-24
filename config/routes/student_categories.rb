get 'student_categories/edit'
get 'student_categories/wing_update/:id' => 'student_categories#wing_update'
get 'student_categories/show'
get 'student_categories/destroy'
get 'student_categories/index', to: 'student_categories#index'
get 'student_categories/getdata', to: 'student_categories#getdata'
resources :student_categories