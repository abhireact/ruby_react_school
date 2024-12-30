class EmployeeArchiveController < ApplicationController
    include JsonResponseHelper # Include the concern
        
    layout "mindcom"
  
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


    def archive_employee
      # Permitting parameters
      params.permit(:archive_date, :mg_archive_reason_id, selectedemployees: [])
  
      # Now, params will be allowed and can be used properly
      employee_ids = params[:selectedemployees]
  
      if employee_ids.blank?
        return render json: {
          status: 'error',
          message: 'Please add employees to archive'
        }
      end
  
      school = MgSchool.find_by(id: session[:current_user_school_id])
      return render json: {
        status: 'error',
        message: 'School not found'
      } unless school
  
      archive_date = Date.parse(params[:archive_date]) rescue nil
      unless archive_date
        return render json: {
          status: 'error',
          message: 'Invalid archive date'
        }
      end
  
      archived_fail_employees = []
  
      employee_ids.each do |eid|
        begin
          employee = MgEmployee.find(eid)
  
          # Ensure joining_date is a Date object, fall back to school calendar start date
          joining_date = employee.joining_date.is_a?(Date) ? employee.joining_date : Date.parse(employee.joining_date.to_s) rescue school.mg_leave_calendar_start_date
  
          # Check if archive date is valid
          if joining_date && archive_date >= joining_date
            if employee.update(
              mg_archive_reason_id: params[:mg_archive_reason_id],
              archive_date: archive_date,
              is_archive: true
            )
              # Successfully archived employee
            else
              archived_fail_employees << "Failed to archive employee #{employee.employee_full_name_with_number}: #{employee.errors.full_messages.join(', ')}"
            end
          else
            archived_fail_employees << "Employee #{employee.employee_full_name_with_number} not archived because the archive date is less than joining date"
          end
        rescue ActiveRecord::RecordNotFound
          archived_fail_employees << "Employee with ID #{eid} not found"
        rescue => e
          archived_fail_employees << "Error archiving employee with ID #{eid}: #{e.message}"
        end
      end
  
      if archived_fail_employees.present?
        render json: {
          status: 'failure',
          message: "#{archived_fail_employees.join(', ')} not archived due to date mismatch or other issues",
          failed_employees: archived_fail_employees
        }
      else
        render json: {
          status: 'success',
          message: 'Employees Archived Successfully'
        }
      end
    end
    
    def unarchive_employee
      employeeID = params[:id]
      @emp = MgEmployee.find_by(id: employeeID)
      
      if @emp.present?
        @emp.update(is_archive: 0, mg_archive_reason_id: "", archive_date: "")
        render json: { success: true, message: "Employee is Unarchived Successfully" }
      else
        render json: { success: false, message: "Employee not found or could not be unarchived" }, status: :not_found
      end
    end
    def update_archive_employee
      employee_archive = MgEmployee.find_by(id: params[:id], mg_school_id: session[:current_user_school_id], is_deleted: 0)
      
      if employee_archive.present?
        employee_archive.mg_archive_reason_id = params[:mg_archive_reason_id]
        employee_archive.archive_date = params[:archive_date]
     
        if employee_archive.save
          render json: {
            success: true,
            message: "Employee updated archive successfully",
            data: employee_archive
          }, status: :ok
        else
          render json: {
            success: false,
            message: "Employee could not be archived",
            errors: employee_archive.errors.full_messages
          }, status: :unprocessable_entity
        end
      else
        render json: {
          success: false,
          message: "Employee not found or already archived",
        }, status: :not_found
      end
    end
    

    def show_archive_employees
      @archive_employees = MgEmployee
        .where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_employee_category_id: 2, is_archive: 1)
        .joins("INNER JOIN mg_users ON mg_users.id = mg_employees.mg_user_id")
        .joins("INNER JOIN mg_employee_departments ON mg_employee_departments.id = mg_employees.mg_employee_department_id")
        .select("mg_employees.*, mg_users.user_name AS user_name, mg_employee_departments.department_name AS department_name")
    
        @employees_data = MgEmployee
        .where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_employee_category_id: 2, is_archive: 0)
        .joins("INNER JOIN mg_users ON mg_users.id = mg_employees.mg_user_id")
        .joins("INNER JOIN mg_employee_departments ON mg_employee_departments.id = mg_employees.mg_employee_department_id")
        .joins("INNER JOIN mg_addresses AS temporary_addresses ON temporary_addresses.mg_user_id = mg_employees.mg_user_id AND temporary_addresses.address_type = 'Temporary'")
        .joins("INNER JOIN mg_addresses AS permanent_addresses ON permanent_addresses.mg_user_id = mg_employees.mg_user_id AND permanent_addresses.address_type = 'Permanent'")
        .select("mg_employees.*, 
                 mg_users.user_name AS user_name, 
                 mg_employee_departments.department_name AS department_name, 
                 temporary_addresses.address_line1 AS temporary_address_line1, 
                 temporary_addresses.address_line2 AS temporary_address_line2, 
                 temporary_addresses.city AS temporary_city, 
                 temporary_addresses.state AS temporary_state, 
                 temporary_addresses.country AS temporary_country, 
                 temporary_addresses.pin_code AS temporary_pin_code,
                 permanent_addresses.address_line1 AS permanent_address_line1, 
                 permanent_addresses.address_line2 AS permanent_address_line2, 
                 permanent_addresses.city AS permanent_city, 
                 permanent_addresses.state AS permanent_state, 
                 permanent_addresses.country AS permanent_country, 
                 permanent_addresses.pin_code AS permanent_pin_code")

      
       
      render_json_response(
        archive_employees: @archive_employees,
        active_employees: @employees_data
      )
    end
    
    
      
  
end
