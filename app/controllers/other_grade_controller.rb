class OtherGradeController < ApplicationController
  include JsonResponseHelper # Include the concern
  
  layout "mindcom"
  
  def index
    if session[:class_table].present?
      @table_array = session[:class_table]
      @course_id = session[:table_array_class_id]
      session[:table_array_employee_id] = nil
      session[:class_table] = nil
    end
    @current_academic_year_id = 175
    @current_academic_year_id = params[:mg_time_table_id] if params[:mg_time_table_id]
    @classes = MgCourse.where(mg_school_id: session[:current_user_school_id], is_deleted: 0,
                              mg_time_table_id: @current_academic_year_id).order(:id)
    @batches = MgBatch.find_by(mg_school_id: session[:current_user_school_id], is_deleted: 0)
    @sectionClass = view_context.get_section_class
    @academic_year_data = MgTimeTable.where(mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id)
    @wings_data = MgWing.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
    @grades_data = MgCbscCoScholasticGrade.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])

    @react_data = {
      table_array: @table_array,
      course_id: @course_id,
      classes: @classes,
      batches: @batches,
      current_academic_year_id: @current_academic_year_id,
      academic_year_data: @academic_year_data,
      wings_data: @wings_data,
      grades_data: @grades_data,
      batches_data: @sectionClass
    }
  end
 
  def show_other_grades
    @grades_data = MgCbscCoScholasticGrade.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
    
    render_json_response(@grades_data)
  end

  def create_other_grade
    @new_grade = MgCbscCoScholasticGrade.new(grade_params)
    if @new_grade.save
      render_json_response({ message: "Grade for Other Exams Created Successfully" }, :created)
    else
      render_json_response({ error: "Error Occurred while Creating Grade" }, :unprocessable_entity)
    end
  end

  def update_other_grade
    @update_grades = MgCbscCoScholasticGrade.find(params[:id])
    if @update_grades.update(grade_params)
      render_json_response({ message: "Grade for Other Exams Updated Successfully" }, :ok)
    else
      render_json_response({ error: @update_grades.errors.full_messages.join(", ") }, :unprocessable_entity)
    end
  end

  def delete_other_grade
    @grades = MgCbscCoScholasticGrade.find(params[:id])
    boolVal = MgDependancyClass.coScholasticExamsType_dependancy("mg_cbsc_co_scholastic_exam_component_id", params[:id])
    
    if boolVal[0]
      render_json_response({ error: "Cannot delete this grade as it has dependencies" }, :unprocessable_entity)
    else
      @grades.update(is_deleted: 1)
      render_json_response({ message: "Deleted Successfully" }, :ok)
    end
  end

  private

  def grade_params
    params.require(:grades).permit(:name, :mg_batch_id, :description, :mg_time_table_id).merge(
      mg_school_id: session[:current_user_school_id],
      created_by: session[:user_id],
      updated_by: session[:user_id],
      is_deleted: 0
    )
  end

  def grade_params_update
    params.require(:grades).permit(:name, :min_score, :credit_points, :description, :scoring_type).merge(
      mg_school_id: session[:current_user_school_id],
      created_by: session[:user_id],
      updated_by: session[:user_id],
      is_deleted: 0
    )
  end
end
