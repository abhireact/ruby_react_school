class ExamReportReleasesController < ApplicationController
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
    @exam_report_data = MgExaminationReportReleaseDate.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)

    @sectionClass = MgBatch.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
                           .joins(:mg_course)
                           .pluck(
                             Arel.sql("CONCAT(mg_courses.course_name, '-', mg_batches.name)"),
                             Arel.sql("mg_batches.id"),
                             Arel.sql("mg_courses.mg_time_table_id"),
                             Arel.sql("mg_courses.mg_wing_id"),
                             Arel.sql("mg_courses.id")
                           ).map do |name, mg_batch_id, mg_time_table_id, mg_wing_id, mg_course_id|
                             {
                               name: name,
                               mg_batch_id: mg_batch_id,
                               mg_time_table_id: mg_time_table_id,
                               mg_wing_id: mg_wing_id,
                               mg_course_id: mg_course_id
                             }
                           end

    @react_data = {
      section_class: @sectionClass,
      classes: @classes,
      batches: @batches,
      academic_year_data: @academic_year_data,
      wings_data: @wings_data,
      exam_report_data: @exam_report_data
    }
  end

  def exam_report_releases_data
    @time_table_id = params[:mg_time_table_id]
    @school_id = session[:current_user_school_id]
    @user_id = session[:user_id]
  
    if @time_table_id.nil? || params[:reportData].nil?
      render_json_response({ error: "Missing required parameters: mg_time_table_id or reportData" }, :unprocessable_entity)
      return
    end
  
    created_records = []
    updated_records = []
  
    (params[:reportData] || []).each do |data|
      batch_id = data[:selected_batch]
  
      unless batch_id && data[:batch_paid_fee_amount_percentage]
        render_json_response({ error: "Missing required fields: batch ID or paid fee amount percentage" }, :unprocessable_entity)
        return
      end
  
      begin
        release_date = data[:batch_release_date].present? ? Date.parse(data[:batch_release_date]) : nil
        guardian_date = data[:batch_guardian_release_date].present? ? Date.parse(data[:batch_guardian_release_date]) : nil
        reopen_date = data[:batch_school_reopen_date].present? ? DateTime.parse(data[:batch_school_reopen_date]) : nil
        due_date = data[:batch_due_date].present? ? Date.parse(data[:batch_due_date]) : nil
      rescue ArgumentError => e
        render_json_response({ error: "Date parsing error: #{e.message}" }, :unprocessable_entity)
        return
      end
  
      paid_fee_percentage = data[:batch_paid_fee_amount_percentage].to_f
  
      report_release_date = MgExaminationReportReleaseDate.find_or_initialize_by(
        mg_time_table_id: @time_table_id,
        mg_batch_id: batch_id,
        mg_school_id: @school_id,
        is_deleted: 0
      )
  
      report_release_date.assign_attributes(
        release_date: release_date,
        guardian_release_date: guardian_date,
        school_reopen_date: reopen_date,
        due_date: due_date,
        paid_fee_amount_percentage: paid_fee_percentage,
        is_released: true,
        is_deleted: false,
        updated_by: @user_id
      )
  
      report_release_date.created_by = @user_id if report_release_date.new_record?
  
      if report_release_date.save
        record = {
          batch_id: batch_id,
          release_date: release_date,
          due_date: due_date,
          guardian_release_date: guardian_date,
          school_reopen_date: reopen_date,
          paid_fee_amount_percentage: paid_fee_percentage
        }
  
        if report_release_date.new_record?
          created_records << record
        else
          updated_records << record
        end
      else
        render_json_response({ error: "Failed to save report release date for batch #{batch_id}" }, :unprocessable_entity)
        return
      end
    end
  
    render_json_response({
      message: "Successfully processed release dates!",
      created_records: created_records,
      updated_records: updated_records
    }, :ok)
  end
  
end
