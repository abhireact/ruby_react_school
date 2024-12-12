class SubSubjectController < ApplicationController
  include JsonResponseHelper # Include the concern for rendering JSON responses

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
      subjects_data: @subjects_data
    }
  end

  def show_sub_subjects
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

  def create_sub_subject
    subject_components = params[:mg_subject_component][:subject_components]
    save_subject_components = []

    subject_components.each do |component|
      subject_component = MgSubjectComponent.new(subject_component_params)
      batch = MgBatch.includes(:mg_course).find(subject_component.mg_batch_id)
      subject_component.mg_course_id = batch.mg_course.id
      subject_component.subject_component_name = component[:name]
      save_subject_components << subject_component
    end

    if MgSubjectComponent.import(save_subject_components)
      render_json_response({ message: "Subject component created successfully" }, :created)
    else
      render_json_response({ error: "Failed to create subject components" }, :unprocessable_entity)
    end
  end

  def update_sub_subject
    @subject_component = MgSubjectComponent.find(params[:id])

    if @subject_component.update(subject_component_params)
      render_json_response({ message: "Subject component updated successfully" }, :ok)
    else
      render_json_response({ error: "Failed to update subject component" }, :unprocessable_entity)
    end
  end

  def delete_sub_subject
    @subject_component = MgSubjectComponent.find(params[:id])

    if @subject_component.update(is_deleted: 1)
      render_json_response({ message: "Subject component deleted successfully" }, :ok)
    else
      render_json_response({ error: "Failed to delete subject component" }, :unprocessable_entity)
    end
  end

  private

  def sub_subjects_params
    params.require(:mg_cbsc_co_scholastic_exam_components)
          .permit(:name, :description, :index, :mg_time_table_id)
          .merge(
            mg_school_id: session[:current_user_school_id],
            created_by: session[:user_id],
            updated_by: session[:user_id],
            is_deleted: 0
          )
  end

  def subject_component_params
    params.require(:mg_subject_component).permit(
      :mg_time_table_id,
      :mg_course_id,
      :mg_batch_id,
      :mg_subject_id,
      :subject_component_name
    ).merge(
      mg_school_id: session[:current_user_school_id],
      created_by: session[:user_id],
      updated_by: session[:user_id],
      is_deleted: 0
    )
  end
end
