 
 get 'cbsc_examinations/scholascti_marks_entry_for_emp'
 get 'cbsc_examinations/get_course_id_by_wing_id'
 get 'cbsc_examinations/scholastic_subject_for_emp'
 get 'cbsc_examinations/other_marks_entry_for_teacher'
 get 'cbsc_examinations/print_student_report'
 get 'cbsc_examinations/select_exams_for_printing'
 post 'cbsc_examinations/print_pdf/:id'=>'cbsc_examinations#print_pdf'
 get 'cbsc_examinations/report_pattern_settings_index'
 get 'cbsc_examinations/report_pattern_settings_new'
 post 'cbsc_examinations/report_pattern_settings_create'
 get 'cbsc_examinations/report_pattern_settings_edit'
 patch 'cbsc_examinations/report_pattern_settings_update/:id'=>'cbsc_examinations#report_pattern_settings_update'
 get 'cbsc_examinations/report_pattern_settings_delete'
 get 'cbsc_examinations/get_batch_id_by_wing'
 get 'cbsc_examinations/report_front_page_settings_index'
 get 'cbsc_examinations/report_front_page_settings_new'
 post 'cbsc_examinations/report_front_page_settings_create'
 get 'cbsc_examinations/report_front_page_settings_edit'
 patch 'cbsc_examinations/report_front_page_settings_update/:id'=>'cbsc_examinations#report_front_page_settings_update'
 get 'cbsc_examinations/report_front_page_settings_delete'
 #cbsc examinations
 get 'cbsc_examinations/other_new/:id'=>'cbsc_examinations#other_new'
 get 'cbsc_examinations/exam_schedule_index'
 get 'cbsc_examinations/exam_schedule_new'
 get 'cbsc_examinations/created_exam_schedule'
 get 'cbsc_examinations/student_report_pdf'
 # get 'cbsc_examinations/other_marksEntry'=>'cbsc_examinations#other_marksEntry'
 get 'cbsc_examinations/co_schlastics_grade_new'
 
 get 'cbsc_examinations/get_wing_course'  
 
 get 'cbsc_examinations/index'
 # get 'cbsc_examinations/new'
 patch 'cbsc_examinations/update/:id'=>'cbsc_examinations#update'
 post 'cbsc_examinations/create'=>'cbsc_examinations#create'
 
 
 patch 'cbsc_examinations/exam_schedule_update/:id'=>'cbsc_examinations#exam_schedule_update'
 #exam_particular
 get 'cbsc_examinations/exam_particular_new'
 get 'cbsc_examinations/exam_particular_index'
 
 #co_scholastics
 
 patch 'cbsc_examinations/co_scholastic_update/:id' => 'cbsc_examinations#co_scholastic_update'
 patch 'cbsc_examinations/descipline_update/:id' => 'cbsc_examinations#descipline_update'
 patch 'cbsc_examinations/co_scholastic_particular_update/:id' => 'cbsc_examinations#co_scholastic_particular_update'
 
 #exam components
 get 'cbsc_examinations/exam_component_new'
 get 'cbsc_examinations/exam_component_index'
 patch 'cbsc_examinations/exam_component_update/:id' => 'cbsc_examinations#exam_component_update'
 post 'cbsc_examinations/exam_component_create'=>'cbsc_examinations#exam_component_create'
 
 #added by deepak
 # get 'cbsc_examinations/grading_for_scolastic'=>'cbsc_examinations#grading_for_scolastic',as: :scholastic_grading
 
 get 'cbsc_examinations/scholastic_grading'=> 'cbsc_examinations#grading_for_scolastic'
 get 'cbsc_examinations/form_grading_for_co_scolastic'=> 'cbsc_examinations#form_grading_for_co_scolastic'
 get 'cbsc_examinations/scholastic_grading/:id'=> 'cbsc_examinations#grading_for_scolastic'
 get 'cbsc_examinations/form_grading_for_scolastic'=> 'cbsc_examinations#form_grading_for_scolastic'
 get 'cbsc_examinations/scholastic_exammanagement_resultEntryIndex/:batch/:id/:mg_time_table_id'=>'cbsc_examinations#scholastic_exammanagement_resultEntryIndex'
 patch 'cbsc_examinations/periodic_test_components_update/:id'=>'cbsc_examinations#periodic_test_components_update'
 patch 'cbsc_examinations/scholastic_particular_update/:id'=>'cbsc_examinations#scholastic_particular_update'
 get 'cbsc_examinations/notebook_submission_components_index'
 get 'cbsc_examinations/notebook_submission_components_new'
 patch 'cbsc_examinations/notebook_submission_components_update/:id'=>'cbsc_examinations#notebook_submission_components_update'
 patch 'cbsc_examinations/subject_enrichment_activity_update/:id'=>'cbsc_examinations#subject_enrichment_activity_update'
 patch 'cbsc_examinations/subject_enrichment_activity_component_update/:id'=>'cbsc_examinations#subject_enrichment_activity_component_update'
 patch 'cbsc_examinations/scholastic_component_update/:id'=>'cbsc_examinations#scholastic_component_update'
 
 get 'cbsc_examinations/students_marks_summary/:mg_batch_id/:mg_course_id/:mg_subject_id/:mg_time_table_id'=>'cbsc_examinations#students_marks_summary'
 get 'cbsc_examinations/other_marks_summary_for_employee'=>'cbsc_examinations#other_marks_summary_for_employee'
 
 get 'cbsc_examinations/exam_attendances'
 get 'cbsc_examinations/exam_attendance_new'
 get 'cbsc_examinations/exam_attendance_edit'
 patch 'cbsc_examinations/exam_attendance_update/:id' => "cbsc_examinations#exam_attendance_update"
 post 'cbsc_examinations/exam_attendance_delete/:id' => "cbsc_examinations#exam_attendance_delete"
 get 'cbsc_examinations/student_remarks_entry'
 post 'cbsc_examinations/student_remarks_entry_create'
 # get 'cbsc_examinations/students_marks_summary'
 get 'cbsc_examinations/final_report'
 
 get '/cbsc_examinations/get_subject_component_by_subject'
 get '/cbsc_examinations/scholastic_marks_summary'
 get '/cbsc_examinations/get_batches_by_course'
 get '/cbsc_examinations/get_employee_course'
 get '/cbsc_examinations/exam_schedule_change'
 get '/cbsc_examinations/exam_schedule_change_details', to: 'cbsc_examinations#exam_schedule_change_details'
 get '/cbsc_examinations/get_exam_particulars', to: 'cbsc_examinations#get_exam_particulars'
 get '/cbsc_examinations/get_exam_types', to: 'cbsc_examinations#get_exam_types'
 get '/cbsc_examinations/onchange_section_of_class_teacher', to: 'cbsc_examinations#onchange_section_of_class_teacher'
 get '/cbsc_examinations/get_batch_id_by_course_ids', to: 'cbsc_examinations#get_batch_id_by_course_ids'
 #cbsc examinations
 
 #react routes
 get '/cbsc_examinations', to:'cbsc_examinations#index'
 post '/cbsc_examinations/create', to: 'cbsc_examinations#create'
 patch '/cbsc_examinations/:id', to: 'cbsc_examinations#update'
 delete  '/cbsc_examinations/:id', to: 'cbsc_examinations#delete'
 resources :cbsc_examinations
  