class AssignTeacherController < ApplicationController

  
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
                                 .where(is_deleted: 0, mg_school_id: session[:current_user_school_id],mg_employee_category_id:2,is_archive:0)
                                 .joins("INNER JOIN mg_users ON mg_users.id = mg_employees.mg_user_id")
                                 .select("mg_employees.*, mg_users.user_name as user_name")
                               
          
       
       
        
            
        
        @react_data = {
            section_class: @sectionClass,
            classes: @classes,
            batches: @batches,
            academic_year_data: @academic_year_data,
            wings_data: @wings_data,
            employees_data:@employees_data
       
          }
        end

        def assign_teacher_update_or_create
            begin
              # Find the batch and update the teacher assignment
              @batch = MgBatch.find(params[:id])
              if @batch.update(mg_employee_id: params[:mg_employee_id])
                # Success response
                render json: { success: true, message: "Teacher Assigned Successfully." }, status: :ok
              else
                # Validation or update error
                render json: { success: false, message: @batch.errors.full_messages.to_sentence }, status: :unprocessable_entity
              end
            rescue ActiveRecord::RecordNotFound
              # Handle record not found
              render json: { success: false, message: "Batch not found." }, status: :not_found
            rescue StandardError => e
              # Handle any other exceptions
              render json: { success: false, message: "An error occurred: #{e.message}" }, status: :internal_server_error
            end
          end


         
          
          
      
end
