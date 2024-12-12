class RemarksEntryController < ApplicationController
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
    @batches = MgBatch.find_by(mg_school_id: session[:current_user_school_id], is_deleted: 0)
    @sectionClass = view_context.get_section_class
    @academic_year_data = MgTimeTable.where(mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id)
    @wings_data = MgWing.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
    @subjects_data = MgSubject.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
    @remarks_entries_data = MgRemarksEntry.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)

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
      remarks_entries_data: @remarks_entries_data
    }
  end

  def create_remarks_entry
    remarks_data = params[:remarks]
    return render_json_response({ error: "Invalid data" }, :bad_request) if remarks_data.blank?

    mg_batch_id = remarks_data[:mg_batch_id]
    course_id = if mg_batch_id.present?
                  MgBatch.find_by(id: mg_batch_id, is_deleted: 0, mg_school_id: session[:current_user_school_id])&.mg_course_id
                else
                  ""
                end

    @remarks = MgRemarksEntry.new(
      mg_time_table_id: remarks_data[:mg_time_table_id],
      mg_course_id: course_id,
      mg_batch_id: mg_batch_id,
      remarks_type: "drop_down",
      index: remarks_data[:index],
      remarks: remarks_data[:remark],
      is_deleted: 0,
      mg_school_id: session[:current_user_school_id],
      created_by: session[:user_id],
      updated_by: session[:user_id]
    )

    if @remarks.save
      render_json_response({ message: "Remarks Entry Created Successfully" }, :created)
    else
      render_json_response({ error: @remarks.errors.full_messages.join(", ") }, :unprocessable_entity)
    end
  end

  def update_remarks_entry
    @remarks = MgRemarksEntry.find_by(id: params[:id], updated_by: session[:user_id])

    if @remarks.present?
      if @remarks.update(
        remarks: params[:remarks][:remark],
        index: params[:remarks][:index],
        updated_by: session[:user_id]
      )
        render_json_response({ message: "Remarks Entry Updated Successfully" }, :ok)
      else
        render_json_response({ error: @remarks.errors.full_messages.join(", ") }, :unprocessable_entity)
      end
    else
      render_json_response({ error: "Remarks Entry Not Found" }, :not_found)
    end
  end

  def delete_remarks_entry
    @remarks = MgRemarksEntry.find_by(id: params[:id])

    if @remarks.present?
      if @remarks.update(is_deleted: 1, updated_by: session[:user_id])
        render_json_response({ message: "Remarks Entry Deleted Successfully" }, :ok)
      else
        render_json_response({ error: "Could Not Delete Remarks Entry" }, :unprocessable_entity)
      end
    else
      render_json_response({ error: "Remarks Entry Not Found" }, :not_found)
    end
  end

  def show_remarks_entry
    @remarks_data = MgRemarksEntry.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])

    render_json_response(@remarks_data)
  end
end
