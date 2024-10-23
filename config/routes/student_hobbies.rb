get 'student_hobbies/edit'
# get 'castes/wing_update/:id' => 'castes#wing_update'
get 'student_hobbies/show'
get 'student_hobbies/destroy'
get 'student_hobbies/index', to: 'student_hobbies#index'
get 'student_hobbies/getdata', to: 'student_hobbies#getdata'
resources :student_hobbies