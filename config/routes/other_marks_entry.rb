get 'other_marks_entry/index', to: 'other_marks_entry#index'
get 'other_marks_entry/show_other_marks_entry', to: 'other_marks_entry#show_other_marks_entry', as:'show_other_marks_entry'

post '/other_marks_entry/create_other_marks_entry', to: 'other_marks_entry#create_other_marks_entry', as: 'create_other_marks_entry'


patch '/other_marks_entry/update_other_marks_entry/:id', to: 'other_marks_entry#update_other_marks_entry', as: 'update_other_marks_entry'


delete '/other_marks_entry/delete_other_marks_entry/:id', to: 'other_marks_entry#delete_other_marks_entry', as: 'delete_other_marks_entry'

  get '/other_marks_entry/other_marksEntry/:mg_course_id/:mg_time_table_id/:mg_batch_id/:mg_cbsc_exam_type_id/:otherPartco_scholastic_component_id/:co_scholastic_particular_id'=>'other_marks_entry#other_marksEntry'

resources :other_marks_entry