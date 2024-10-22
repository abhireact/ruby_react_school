class EmpSubjectsController < ApplicationController
    layout "mindcom"
    
    def index
      employee_category = MgEmployeeCategory.find_by(
        category_name: "Teaching Staff", 
        is_deleted: 0
      )
      
      employees = MgEmployee.where(
        is_deleted: 0,
        mg_employee_category_id: employee_category.id,
        mg_school_id: session[:current_user_school_id],
        is_archive: 0
      )
  
      if params[:api_request]
        render json: {
          employees: employees,
          employee_category: employee_category
        }
      else
        @data = {
          employees: employees,
          employee_category: employee_category
        }
      end
    end


    def select_subject_emp
        @employee = MgEmployee.find(params[:id])
        emp_id = @employee.id
        @subjects = MgSubject.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
        @selected_subjects = MgEmployeeSubject.where(
          mg_employee_id: emp_id, is_deleted: 0, mg_school_id: session[:current_user_school_id]
        ).pluck(:mg_subject_id)
        @courses = MgCourse.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).pluck(:course_name, :id)
      end
      
      def emp_subject
        # Initialize @emp_subjects as a new object of MgEmployeeSubject
        @emp_subjects = MgEmployeeSubject.new
      
        @emp_subjects.mg_school_id = session[:current_user_school_id]
        @emp_subjects.is_deleted = 0
        @emp_subjects.created_by = session[:user_id]
        @emp_subjects.updated_by = session[:user_id]
      
        if request.xhr?
          employee_id = params[:employee]
          assigned_subjects = params[:assigned_subjects].to_a
          unassigned_sub = params[:batch_sub].to_a - assigned_subjects
      
          # Unassign subjects
          unassigned_sub.each do |subject_id|
            MgEmployeeSubject.where(
              mg_employee_id: employee_id,
              mg_subject_id: subject_id,
              is_deleted: 0,
              mg_school_id: session[:current_user_school_id]
            ).update_all(is_deleted: 1)
          end
      
          # Assign new subjects
          assigned_subjects.each do |subject_id|
            MgEmployeeSubject.find_or_create_by(
              mg_employee_id: employee_id,
              mg_subject_id: subject_id,
              is_deleted: 0,
              mg_school_id: session[:current_user_school_id]
            )
          end
      
          render js: "window.location = '/subjects/emp_subject_asso'"
        end
      end
      
      
      
      



       # Select subjects for an employee
  def select_subject_emp
    @employee = MgEmployee.find(params[:id])
    emp_id = @employee.id
    @subjects = MgSubject.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
    @selected_subjects = MgEmployeeSubject.where(
        mg_employee_id: emp_id, is_deleted: 0, mg_school_id: session[:current_user_school_id]
        ).pluck(:mg_subject_id)
    @courses = MgCourse.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).pluck(:course_name, :id)
end



def get_subject_batch_id
    Rails.logger.debug "Parameters: #{params.inspect}"
    return unless params[:mg_course_id].present?
  
    # Fetch batch IDs based on course ID
    batch_ids = MgBatch.where(mg_course_id: params[:mg_course_id], is_deleted: false).pluck(:id)
    Rails.logger.debug "Batch IDs: #{batch_ids}"
  
    # Fetch subjects assigned to the employee
    @employee_subjects = MgEmployeeSubject.where(
      is_deleted: false,
      mg_school_id: session[:current_user_school_id],
      mg_employee_id: params[:employee]
    ).pluck(:mg_subject_id)
    Rails.logger.debug "Employee Subjects: #{@employee_subjects}"
  
    # Fetch subjects associated with the selected batches
    @batch_subjects = MgBatchSubject.where(
      is_deleted: false,
      mg_school_id: session[:current_user_school_id],
      mg_batch_id: batch_ids
    ).pluck(:mg_subject_id)
    Rails.logger.debug "Batch Subjects: #{@batch_subjects}"
  
    # Get assigned subjects for the selected employee from the batch subjects
    assigned_subject_ids = @batch_subjects & @employee_subjects
    @assigned_subjects = MgSubject.where(
      is_deleted: false,
      mg_school_id: session[:current_user_school_id],
      id: assigned_subject_ids
    )
  
    # Get all subjects from the batches
    @subjects = MgSubject.where(
      is_deleted: false,
      mg_school_id: session[:current_user_school_id],
      id: @batch_subjects
    )
  
    # Filter to find the available subjects that are not assigned to the employee
    available_subjects_ids = @batch_subjects - @employee_subjects
    @available_subjects = MgSubject.where(
      is_deleted: false,
      mg_school_id: session[:current_user_school_id],
      id: available_subjects_ids
    )
  
    render json: {
      assigned_subjects: @assigned_subjects,
      available_subjects: @available_subjects
    }
  end
  
      
      
      

      def show
        @subject = MgSubject.find_by(id: params[:id])
        if @subject
          render json: @subject
        else
          render json: { error: 'Subject not found' }, status: :not_found
        end
      end
      
      

  end