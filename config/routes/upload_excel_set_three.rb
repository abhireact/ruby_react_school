get 'upload_excel_set_three/template3_exists', to: 'upload_excel_set_three#template3_exists', as: 'template3_exists'

post '/upload_excel_set_three/upload_castes', to: 'upload_excel_set_three#upload_castes', as: 'upload_castes'
post '/upload_excel_set_three/upload_caste_categories' , to:'upload_excel_set_three#upload_caste_categories' ,as: 'upload_caste_categories'

post '/upload_excel_set_three/upload_student_categories' , to:'upload_excel_set_three#upload_student_categories' ,as: 'upload_student_categories'

post '/upload_excel_set_three/upload_house_details' , to:'upload_excel_set_three#upload_house_details' ,as: 'upload_house_details'

post '/upload_excel_set_three/upload_subject_details' , to:'upload_excel_set_three#upload_subject_details' ,as: 'upload_subject_details'

post '/upload_excel_set_three/upload_batch_subjects' , to:'upload_excel_set_three#upload_batch_subjects' ,as: 'upload_batch_subjects'

post '/upload_excel_set_three/upload_students' , to:'upload_excel_set_three#upload_students' ,as: 'upload_students'

resources :upload_excel_set_three
