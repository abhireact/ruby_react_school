class OtherMarksEntryController < ApplicationController
    include JsonResponseHelper # Include the concern for rendering JSON responses

    layout "mindcom"
  
    def index
      if session[:class_table].present?
        @table_array = session[:class_table]
        @course_id = session[:table_array_class_id]
        session[:table_array_employee_id] = nil
        session[:class_table] = nil
      end
      @exam_types_data = MgCbscExamTypeAssociation
      .joins(:mg_cbsc_exam_type) # Assumes association is defined as belongs_to :mg_cbsc_exam_type
      .where(is_deleted: false, mg_school_id: session[:current_user_school_id])
      .order(:id)
      .select('mg_cbsc_exam_type_associations.*, mg_cbsc_exam_types.exam_type_name')
      @classes = MgCourse.where(mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id)
      @batches = MgBatch.find_by(mg_school_id: session[:current_user_school_id], is_deleted: 0)
    
      @academic_year_data = MgTimeTable.where(mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id)
      @wings_data = MgWing.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
      @subjects_data = MgSubject.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
      @subject_component_data = MgSubjectComponent
                                .joins('INNER JOIN mg_courses ON mg_courses.id = mg_subject_components.mg_course_id')
                                .joins('INNER JOIN mg_batches ON mg_batches.id = mg_subject_components.mg_batch_id')
                                .joins('INNER JOIN mg_subjects ON mg_subjects.id = mg_subject_components.mg_subject_id')
                                .where(is_deleted: false, mg_school_id: session[:current_user_school_id])
                                .select(
                                  'mg_subject_components.*, 
                                  mg_courses.course_name AS course_name, 
                                  mg_batches.name AS batch_name, 
                                  mg_subjects.subject_name AS subject_name'
                                )
      @other_grades_data = MgCbscCoScholasticGrade.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])

      @sectionClass = MgBatch.where(
                                  is_deleted: 0,
                                  mg_school_id: session[:current_user_school_id]
                                ).joins(:mg_course).pluck(
                                  Arel.sql("CONCAT(mg_courses.course_name, '-', mg_batches.name)"),
                                  Arel.sql("mg_batches.id"),
                                  Arel.sql("mg_courses.mg_time_table_id"),
                                
                                  Arel.sql("mg_courses.id") # Add mg_course_id here
                                ).map do |name, mg_batch_id, mg_time_table_id, mg_course_id|
                                  {
                                  name: name,
                                  mg_batch_id: mg_batch_id,
                                  mg_time_table_id: mg_time_table_id,
                                  mg_course_id: mg_course_id # Include mg_course_id in the result
                                  }
                                end
      @particular_component_data = MgCbscCoScholasticExamParticular .where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).joins("LEFT JOIN mg_cbsc_co_scholastic_exam_components ON mg_cbsc_co_scholastic_exam_components.id = mg_cbsc_co_scholastic_exam_particulars.mg_cbsc_co_scholastic_exam_component_id")
        .select("mg_cbsc_co_scholastic_exam_components.name AS other_particular_name, mg_cbsc_co_scholastic_exam_components.id AS other_particular_id, mg_cbsc_co_scholastic_exam_particulars.name AS other_component_name, mg_cbsc_co_scholastic_exam_particulars.id AS other_component_id").order(:id)
        @particular_class_section = MgCbscCoSchoParticularClassAssoc
        .joins("INNER JOIN mg_cbsc_co_scholastic_exam_components ON mg_cbsc_co_scholastic_exam_components.id = mg_cbsc_co_scho_particular_class_assocs.mg_co_scholastic_exam_particular_id")
        .where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
        .select("mg_cbsc_co_scho_particular_class_assocs.*, mg_cbsc_co_scholastic_exam_components.name as particular_name")
        .order(:mg_co_scholastic_exam_particular_id)
      	# @other_marks = MgCbscOtherMarksEntry.where(:mg_batch_id=>@batch_id, :mg_cbsc_exam_type_id=>@mg_cbsc_exam_type_id, :mg_cbsc_co_scholastic_exam_particular_id=>@co_scholastic_particular_id, :mg_cbsc_co_scholastic_exam_component_id=>@co_scholastic_component_id, :mg_school_id => session[:current_user_school_id], :is_deleted=>0)
        @other_marks_data = MgCbscOtherMarksEntry.where( mg_school_id:session[:current_user_school_id], is_deleted:0).order("mg_batch_id asc")
        @students_list_data = view_context.get_students_by_current_academic_year( session[:current_user_school_id])
        
        @react_data = {
        table_array: @table_array,
        course_id: @course_id,
        classes: @classes,
        batches: @batches,
        current_academic_year_id: @current_academic_year_id,
        academic_year_data: @academic_year_data,
        wings_data: @wings_data,
        subject_component_data: @subject_component_data,
        batches_data: @sectionClass,
        subjects_data: @subjects_data,
        exam_types_data:@exam_types_data,
        particular_component_data:@particular_component_data,
        particular_class_section:@particular_class_section,
        other_grades_data:@other_grades_data,
        other_marks_data:@other_marks_data,
        students_list_data:@students_list_data
      }
    end
  
    def show_other_marks_entry
      @subject_component_data = MgSubjectComponent
                                .joins('INNER JOIN mg_courses ON mg_courses.id = mg_subject_components.mg_course_id')
                                .joins('INNER JOIN mg_batches ON mg_batches.id = mg_subject_components.mg_batch_id')
                                .joins('INNER JOIN mg_subjects ON mg_subjects.id = mg_subject_components.mg_subject_id')
                                .where(is_deleted: false, mg_school_id: session[:current_user_school_id])
                                .select(
                                  'mg_subject_components.*, 
                                  mg_courses.course_name AS course_name, 
                                  mg_batches.name AS batch_name, 
                                  mg_subjects.subject_name AS subject_name'
                                )
  
      render_json_response(@subject_component_data)
    end
    def other_marksEntry
      @course = view_context.get_classes
    
      if params[:mg_course_id].present?
    
        @batch_id = params[:mg_batch_id]
        @mg_course_id = params[:mg_course_id]
        @mg_cbsc_exam_type_id = params[:mg_cbsc_exam_type_id]
        @co_scholastic_component_id = params[:otherPartco_scholastic_component_id]
        @co_scholastic_particular_id = params[:co_scholastic_particular_id]
    
        students_list = MgStudent.where(is_deleted: 0, mg_school_id: session[:current_user_school_id], is_archive: 0)
                                 .where(id: (
                                   MgStudent.where(is_deleted: 0, mg_school_id: session[:current_user_school_id], is_archive: 0, mg_batch_id: @batch_id).pluck(:id) +
                                   MgStudentBatchHistory.where(from_academic_year: params[:mg_time_table_id], from_section_id: @batch_id, mg_school_id: session[:current_user_school_id], is_deleted: false).pluck(:mg_student_id)
                                 ).uniq)
    
        if params[:sort].present? || params[:direction].present?
          @studentObj = students_list.order(sort_column + " " + sort_direction)
        else
          @studentObj = students_list.order("roll_number asc")
        end
    
        user = MgUser.find_by(id: session[:user_id])
        @user_type = user.user_type
        @class_teacher = false
    
        if "employee".casecmp(@user_type) == 0
          employee = MgEmployee.find_by(mg_user_id: user.id)
          batch = MgBatch.find_by(id: @batch_id)
          if batch&.mg_employee_id.present?
            @class_teacher = true if batch.mg_employee_id == employee.id
          end
        end
    
        @other_marks = MgCbscOtherMarksEntry.where(
          mg_batch_id: @batch_id,
          mg_cbsc_exam_type_id: @mg_cbsc_exam_type_id,
          mg_cbsc_co_scholastic_exam_particular_id: @co_scholastic_particular_id,
          mg_cbsc_co_scholastic_exam_component_id: @co_scholastic_component_id,
          mg_school_id: session[:current_user_school_id],
          is_deleted: 0
        )
    
        @co_scholastics_grade = MgCbscCoScholasticGrade.where(
          mg_batch_id: @batch_id,
          mg_school_id: session[:current_user_school_id],
          is_deleted: 0,
          mg_time_table_id: params[:mg_time_table_id]
        ).pluck(:name, :id)
    
        if @co_scholastics_grade.empty?
          @co_scholastics_grade = MgCbscCoScholasticGrade.where(
            mg_batch_id: nil,
            mg_school_id: session[:current_user_school_id],
            is_deleted: 0,
            mg_time_table_id: params[:mg_time_table_id]
          ).pluck(:name, :id)
        end
    
        @scoring_type = MgCbscCoScholasticExamParticular.find_by(
          id: @co_scholastic_particular_id,
          mg_school_id: session[:current_user_school_id],
          is_deleted: 0
        )
    
        # Enhance the students list with otherGrade
        other_marks_map = @other_marks.index_by(&:mg_student_id)
        students_with_grades = @studentObj.map do |student|
          other_grade = other_marks_map[student.id]&.mg_cbsc_co_scholastic_grade_id
          student.attributes.merge(otherGrade: other_grade)
        end
    
        render_json_response({ students: students_with_grades, other_marks: @other_marks })
      end
    end
    

    def create_other_marks_entry
      begin
        # Ensure we have the examMarksEntry parameter
        raise "No examMarksEntry provided" unless params[:examMarksEntry].present?
    
        # Extract parameters with default empty arrays/hashes
        student_ids = params[:examMarksEntry][:student_ids]
        modified_students = params[:examMarksEntry][:modified_students]
        co_scholastic_grade = params[:examMarksEntry][:co_scholastic_grade]
        co_scholastic_grade_comments = params[:examMarksEntry][:co_scholastic_grade_comments]
        co_scholastic_obtained_marks = params[:examMarksEntry][:co_scholastic_obtained_marks]
        rollNumber = params[:examMarksEntry][:rollNumber]
    
        # Convert modified students to integers
        modified_student_ids = modified_students.map(&:to_i).uniq
       
        other_marks_entry_save = []
    
        student_ids.each_with_index do |student_id, i|
          student = MgStudent.find(student_id)
         
          # Update roll number if the student was modified
          if modified_student_ids.include?(student.id)
            student.update(roll_number: rollNumber[i])
           
          end
    
          # Find existing marks entry
          @other_marks_entry = MgCbscOtherMarksEntry.find_by(
            mg_cbsc_exam_type_id: params[:examMarksEntry][:mg_cbsc_exam_type_id],
            mg_school_id: session[:current_user_school_id],
            is_deleted: 0,
            mg_student_id: student_id,
            mg_cbsc_co_scholastic_exam_component_id: params[:examMarksEntry][:mg_cbsc_co_scholastic_exam_component_id],
            mg_cbsc_co_scholastic_exam_particular_id: params[:examMarksEntry][:mg_cbsc_co_scholastic_exam_particular_id],
            mg_batch_id: params[:examMarksEntry][:mg_batch_id]
          )
    
          if @other_marks_entry.present?
            # Update existing entry
            @other_marks_entry_update = MgCbscOtherMarksEntry.find(@other_marks_entry.id)
    
      if co_scholastic_grade.any?
              update_params = {
                mg_cbsc_co_scholastic_grade_id: co_scholastic_grade[i]
              }
    
              if co_scholastic_grade_comments.any?
                update_params[:grade_comment] = co_scholastic_grade_comments[i]
              end
    
              @other_marks_entry_update.update(update_params)
            end
          else
            # Create new entry
            other_marks_entry = MgCbscOtherMarksEntry.new(other_params)
    
            other_marks_entry.mg_batch_id = params[:examMarksEntry][:mg_batch_id]
    
            if co_scholastic_grade.any?
              other_marks_entry.mg_cbsc_co_scholastic_grade_id = co_scholastic_grade[i]
              other_marks_entry.grade_comment = co_scholastic_grade_comments[i] if co_scholastic_grade_comments.any?
            end
    
            other_marks_entry.mg_student_id = student_id
            other_marks_entry.mg_cbsc_exam_type_id = params[:examMarksEntry][:mg_cbsc_exam_type_id]
            other_marks_entry.mg_cbsc_co_scholastic_exam_particular_id = params[:examMarksEntry][:mg_cbsc_co_scholastic_exam_particular_id]
            other_marks_entry.mg_cbsc_co_scholastic_exam_component_id = params[:examMarksEntry][:mg_cbsc_co_scholastic_exam_component_id]
    
            other_marks_entry_save << other_marks_entry
          end
        end
    
        # Bulk import new entries if any
        MgCbscOtherMarksEntry.import other_marks_entry_save if other_marks_entry_save.any?
    
        render json: {
          success: true,
          message: 'Marks entry updated successfully',
          data: other_marks_entry_save
        }
      rescue StandardError => e
        Rails.logger.error "Error in create_other_marks_entry: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        render json: {
          success: false,
          message: "An error occurred: #{e.message}"
        }, status: 500
      end
    end
    
    def other_params
      params.require(:examMarksEntry).permit(
        :mg_cbsc_exam_type_id,
        :mg_cbsc_co_scholastic_exam_particular_id,
        :mg_cbsc_co_scholastic_exam_component_id ,
        :obtained_marks
      ).merge(
        mg_school_id: session[:current_user_school_id],
        created_by: session[:user_id],
        updated_by: session[:user_id],
        is_deleted: 0
      )
    end
    
    

  end
  
