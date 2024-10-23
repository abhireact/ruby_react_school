get 'attendances/get_dates_presence'
get 'attendances/employee_holiday_attendance_new'
get 'attendances/get_holiday_and_employee_department'
get 'attendances/get_employee_list'
get 'attendances/getStartDateEndDate'
patch 'attendances/attendance_import'=>'attendances#attendance_import',as: :attendance_import
get 'attendances/period_wise_attendance_for_student_guardian'=>'attendances#period_wise_attendance_for_student_guardian', as: :period_wise_attendance_for_student_guardian
get 'attendances/period_wise_attendance_for_student'=>'attendances#period_wise_attendance_for_student', as: :period_wise_attendance_for_student
get 'attendances/period_attendence_edit/:id'=>'attendances#period_attendence_edit', as: :period_attendence_edit
get 'attendances/attendance_new_period'=>'attendances#attendance_new_period', as: :attendance_new_period
# get 'attendances/folder_edit/:id'=>'attendances#folder_edit',  as: :folder_edits
post 'attendances/attendance_create/;id'=>'attendances#attendance_create',  as: :attendance_create
get 'attendances/period_attendence_save/:id'=>'attendances#period_attendence_save', as: :period_attendence_save
get 'attendances/time_table_for_attendance'=>'attendances#time_table_for_attendance', as: :time_table_for_attendance
get 'attendances/update_absent'=>'attendances#update_absent', as: :update_absent
get 'attendances/update_present'=>'attendances#update_present', as: :update_present
get 'attendances/employee_student_attendance'=>'attendances#employee_student_attendance', as: :employee_student_attendance
get 'attendances/apply_leave_for_student'=>'attendances#apply_leave_for_student'
patch 'attendances/delete/:id'=>'attendances#delete'
post 'attendances/apply_leave/:id'=> 'attendances#createstudent'
get 'attendances/student_index'
get 'attendances/student'
get 'attendances/view_attendance'=>'attendances#view_attendance', as: :attendance_guardian
get 'attendances/gardian_index'
get 'attendances/holiday_lists'
post 'attendances/holiday_new'
get 'attendances/holiday_submit'
get 'attendances/holidays_pdf'
get 'attendances/studentsHash'
get 'attendances/index'
get 'attendances/apply_leave' => 'attendances#apply_leave'
get 'attendances/attendances_incharge_page' => 'attendances#attendances_incharge_page'
get 'attendances/get_batch_of_employee'
get 'attendances/get_student_data'
resources :attendances
