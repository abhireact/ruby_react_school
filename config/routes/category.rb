
#extra_curricular
get '/category/extra_curricular_index'=>'category#extra_curricular_index'
get '/category/extra_curricular_new'=>'category#extra_curricular_new'
post '/category/extra_curricular_create'=>'category#extra_curricular_create'
patch '/category/extra_curricular_update/:id'=>'category#extra_curricular_update'


#extra_curricular

#sports
get '/category/sport_new'=>'category#sport_new'
get '/category/sport_index'=>'category#sport_index'
post '/category/sport_create'=>'category#sport_create'
patch '/category/sport_update/:id'=>'category#sport_update'

#sports
get '/category/student_hobbies'=>'category#student_hobbies'
post '/category/student_hobbies_create'=>'category#student_hobbies_create'
patch '/category/student_hobbies_update/:id'=>'category#student_hobbies_update'

get 'category/caste_new'
get 'category/caste_edit'
get 'category/caste_update'
get 'category/caste_show'
get 'category/caste_delete'
get 'category/create'
get 'category/caste'

get 'category/castecategory'
get 'category/castecategory_new'
get 'category/castecategory_edit'
get 'category/castecategory_update'
get 'category/castecategory_show'
get 'category/castecategory_delete'
get 'category/castecategory_create'
