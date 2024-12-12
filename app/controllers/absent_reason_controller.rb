class AbsentReasonController < ApplicationController  
    include JsonResponseHelper # Include the concern for JSON responses
  
  layout 'mindcom'

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
     
      @academic_year_data = MgTimeTable.where(mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id)
      @wings_data = MgWing.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
      @mgabsents = MgExaminationAbsentReason.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
  
      @react_data = {
        table_array: @table_array,
        course_id: @course_id,
        classes: @classes,
        batches: @batches,
        current_academic_year_id: @current_academic_year_id,
        academic_year_data: @academic_year_data,
        wings_data: @wings_data,
    
        absent_reason_data: @mgabsents
       
      }
  end
  
  def show_absent_reasons
    @mgabsents = MgExaminationAbsentReason.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
                                         
    render_json_response(@mgabsents)
  end


  def create_absent_reason
    @mgabsent = MgExaminationAbsentReason.new(absent_params)
    if @mgabsent.save
      render_json_response({ message: "Absent Reason Created Successfully" }, :created)
    else
      render_json_response({ error: @mgabsent.errors.full_messages.join(", ") }, :unprocessable_entity)
    end
  end

  

  def update_absent_reason
    @mgabsent = MgExaminationAbsentReason.find(params[:id])
    @mgabsent.is_applicable = false if params[:mg_examination_absent_reason][:is_applicable].nil?

    if @mgabsent.update(absent_params)
      render_json_response({ message: "Absent Reason Updated Successfully" }, :ok)
    else
      render_json_response({ error: @mgabsent.errors.full_messages.join(", ") }, :unprocessable_entity)
    end
  end

  def delete_absent_reason
    @mgabsent = MgExaminationAbsentReason.find(params[:id])
    if @mgabsent.update(is_deleted: 1)
      render_json_response({ message: "Absent Reason Archived Successfully" }, :ok)
    else
      render_json_response({ error: "Error Occurred while Archiving" }, :unprocessable_entity)
    end
  end

  private

  def absent_params
    params.require(:mg_examination_absent_reason).permit(:name, :code, :is_applicable).merge(
      mg_school_id: session[:current_user_school_id],
      created_by: session[:user_id],
      updated_by: session[:user_id],
      is_deleted: 0
    )
  end
end