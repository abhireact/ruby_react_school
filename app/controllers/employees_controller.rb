class EmployeesController < ApplicationController

    def index
     if session[:class_table].present?
        @table_array = session[:class_table]
        @course_id = session[:table_array_class_id]
        session[:table_array_employee_id] = nil
        session[:class_table] = nil
      end
  
      @classes = MgCourse.where(mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id)
      @batches = MgBatch.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
      @academic_year_data = MgTimeTable.where(mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id)
      @wings_data = MgWing.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
      @sectionClass = MgBatch.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
                             .joins(:mg_course)
                             .pluck(
                               Arel.sql("CONCAT(mg_courses.course_name, '-', mg_batches.name)"),
                               Arel.sql("mg_batches.id"),
                               Arel.sql("mg_batches.mg_employee_id"),
                               Arel.sql("mg_courses.mg_time_table_id"),
                               Arel.sql("mg_courses.mg_wing_id"),
                               Arel.sql("mg_courses.id")
                             ).map do |name, mg_batch_id,mg_employee_id, mg_time_table_id, mg_wing_id, mg_course_id|
                               {
                                 name: name,
                                 mg_batch_id: mg_batch_id,
                                 mg_employee_id:mg_employee_id,
                                 mg_time_table_id: mg_time_table_id,
                                 mg_wing_id: mg_wing_id,
                                 mg_course_id: mg_course_id
                               }
                             end
                             @employees_data = MgEmployee
                             .where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_employee_category_id: 2, is_archive: 0)
                             .joins("INNER JOIN mg_users ON mg_users.id = mg_employees.mg_user_id")
                             .joins("INNER JOIN mg_employee_departments ON mg_employee_departments.id = mg_employees.mg_employee_department_id")
                             .select("mg_employees.*, mg_users.user_name AS user_name, mg_employee_departments.department_name AS department_name")
                             @archive_data = MgEmployee
                             .where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_employee_category_id: 2, is_archive: 1)
                             .joins("INNER JOIN mg_users ON mg_users.id = mg_employees.mg_user_id")
                             .joins("INNER JOIN mg_employee_departments ON mg_employee_departments.id = mg_employees.mg_employee_department_id")
                             .select("mg_employees.*, mg_users.user_name AS user_name, mg_employee_departments.department_name AS department_name")
                           
                        
       @reasons_data =MgArchiveReason.where(is_deleted: 0,user_type:"Employee").pluck(:reason_name,:id)
       @employee_department=MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:department_name,:id)
                           
      
   
   
    
        
    
      @react_data = {
        section_class: @sectionClass,
        classes: @classes,
        batches: @batches,
        academic_year_data:@academic_year_data,
        wings_data:@wings_data,
        employees_data:@employees_data,
        reasons_data:@reasons_data,
        employee_department:@employee_department,
        archive_data:@archive_data
      }
    end

end
