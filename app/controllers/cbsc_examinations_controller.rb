class CbscExaminationsController < ApplicationController
  layout 'mindcom'
  #include CheckExamReport, GetParticularGrade
  include ApplicationHelper 
  
  helper_method :get_class_section, :sort_column, :sort_direction
    
   


  # before_action :login_required
  before_action :set_exam_type, only: %i[show edit update destroy]

  def index
    @current_academic_year = view_context.get_current_academic_year(session[:current_user_school_id])
    @current_academic_year_id = @current_academic_year.last
    @current_academic_year_id = params[:mg_time_table_id] if params[:mg_time_table_id].present?
    @classes = MgCourse.where(mg_school_id: session[:current_user_school_id], is_deleted: 0,
                              mg_time_table_id: @current_academic_year_id).order(:id)
    @batches = MgBatch.find_by(mg_school_id: session[:current_user_school_id], is_deleted: 0)

    @exam_types = MgCbscExamType.where(is_deleted: false, mg_school_id: session[:current_user_school_id], mg_time_table_id: @current_academic_year_id)
    @classSection = view_context.get_class_section
    @academicYearsData= MgTimeTable.where(mg_school_id:session[:current_user_school_id],is_deleted:0)
    @examtypes_associations = MgCbscExamTypeAssociation.where(is_deleted: false, mg_school_id: session[:current_user_school_id]).order(:mg_course_id)
    @react_data = {
      academic_year_data:@current_academic_year,
      examtype_data: @exam_types,
      classes: @classes,
      batches: @batches,
      class_section:@classSection,
      academicYearsData:@academicYearsData,
      exam_associationData:@examtypes_associations
    }
  end

  def show
    @id = params[:id]
  end

  def new
    @action = "new"
    @exam_type = MgCbscExamType.new
    @mg_time_table_id = params[:mg_time_table_id]
    @class_array = []
    courses = MgCourse.where(is_deleted: false, mg_school_id: session[:current_user_school_id], mg_time_table_id: @mg_time_table_id).pluck(:course_name, :id)
    courses.each do |course|
      batches = MgBatch.where(is_deleted: false, mg_school_id: session[:current_user_school_id], mg_course_id: course[1])
      batches.each do |batch|
        @class_array.push(["#{course[0]}-#{batch.name}", "#{course[1]}-#{batch.id}"])
      end
    end
  end

  def create
    @exam_type = MgCbscExamType.new(exam_params)
    @exam_type.mg_time_table_id = params[:mg_time_table_id].to_i
    @exam_type.is_deleted = 0
    @exam_type.mg_school_id = session[:current_user_school_id]
    @exam_type.created_by = session[:user_id]
    @exam_type.updated_by = session[:user_id]
    if @exam_type.save
      selected_class = params[:selected_class]
      if selected_class.present?
        selected_class.each do |class_item|
          course_id, batch_id = class_item.split("-")
          MgCbscExamTypeAssociation.create(mg_course_id: course_id,mg_batch_id: batch_id,mg_cbsc_exam_type_id: @exam_type.id,created_by: session[:user_id],updated_by: session[:user_id],is_deleted: false,mg_school_id: session[:current_user_school_id]
          )
        end
      end
              
          render json: { message: "Exam Type  Created"}, status: :created
    else
      flash[:error] = "Exam Type is Already Used, Please Try Another Name"
    end
    # redirect_to action: "index"
  end

  def edit
    @action = "edit"
    @selected_array = []
    @mg_time_table_id = params[:mg_time_table_id]
    exam_associations = MgCbscExamTypeAssociation.where(mg_cbsc_exam_type_id: @exam_type.id, is_deleted: false, mg_school_id: session[:current_user_school_id]).order(:mg_course_id)
    exam_associations.each do |exam|
      courses = MgCourse.where(id: exam.mg_course_id, is_deleted: false, mg_school_id: session[:current_user_school_id], mg_time_table_id: params[:mg_time_table_id]).pluck(:course_name, :id)
      courses.each do |course|
        batches = MgBatch.where(id: exam.mg_batch_id, is_deleted: false, mg_school_id: session[:current_user_school_id], mg_course_id: course[1])
        batches.each do |batch|
          @selected_array.push(["#{course[0]}-#{batch.name}", "#{course[1]}-#{batch.id}"])
        end
      end
    end

    # Prepare available classes
    @class_array = []
    remaining_batches = MgBatch.where(is_deleted: false, mg_school_id: session[:current_user_school_id]).where.not(id: exam_associations.pluck(:mg_batch_id)).pluck(:name, :id, :mg_course_id)
    remaining_batches.each do |batch|
      course = MgCourse.find_by(id: batch[2], is_deleted: false, mg_school_id: session[:current_user_school_id], mg_time_table_id: params[:mg_time_table_id])
      @class_array.push(["#{course.course_name}-#{batch[0]}", "#{course.id}-#{batch[1]}"]) if course
    end
  end

  def update
    if @exam_type.update(exam_params)
      update_exam_type_associations(params[:selected_class], params[:delete_class])
      render json: { message: "Exam Type updated successfully!" }, status: :ok
    else
      render json: { error: "Failed to update Exam Type." }, status: :unprocessable_entity
    end
  end

  def destroy
    if dependency_exists?("mg_cbsc_exam_type_id", params[:id])
       render json: { error: "Cannot delete this Exam Type as it has dependencies." }, status: :unprocessable_entity
  
    else
      @exam_type.update(is_deleted: true)
      MgCbscExamTypeAssociation.where(mg_cbsc_exam_type_id: @exam_type.id).update_all(is_deleted: true)
      render json: { message: "Exam Type Deleted"}, status: :created
    end
    # redirect_to action: "index"
  end


  def delete
    @exam_type = MgCbscExamType.find(params[:id])
    boolVal = MgDependancyClass.examType_dependancy("mg_cbsc_exam_type_id", params[:id])
    
    if boolVal == true
      render json: { error: "Cannot delete this Exam Type as it has dependencies." }, status: :unprocessable_entity
    else
      @exam_type.update(is_deleted: 1)
      
      @exam_type_association = MgCbscExamTypeAssociation.where(mg_cbsc_exam_type_id: @exam_type.id)
      @exam_type_association.each do |exam_type_association|
        exam_type_association.update(is_deleted: 1)
      end
      
      render json: { message: "Deleted successfully." }, status: :ok
    end
  end
  

  private

  def set_exam_type
    @exam_type = MgCbscExamType.find(params[:id])
  end

  def update_exam_type_associations(selected_classes, deleted_classes)
    # Deleting existing associations
    if deleted_classes.present?
      deleted_classes.each do |class_item|
        course_id, batch_id = class_item.split("-")
        exam_association = MgCbscExamTypeAssociation.find_by(mg_cbsc_exam_type_id: @exam_type.id, mg_course_id: course_id, mg_batch_id: batch_id, is_deleted: false)
        exam_association.update(is_deleted: true) if exam_association
      end
    end

    # Adding new associations
    if selected_classes.present?
      selected_classes.each do |class_item|
        course_id, batch_id = class_item.split("-")
        exam_association = MgCbscExamTypeAssociation.find_or_initialize_by(mg_cbsc_exam_type_id: @exam_type.id, mg_course_id: course_id, mg_batch_id: batch_id, is_deleted: false)
        unless exam_association.persisted?
          exam_association.assign_attributes(
            created_by: session[:user_id],
            updated_by: session[:user_id],
            mg_school_id: session[:current_user_school_id]
          )
          exam_association.save
        end
      end
    end
  end

  def dependency_exists?(field, id)
    MgDependancyClass.gradeScholasticExamsType_dependancy(field, id)
  end

  def exam_params
    params.require(:mg_cbsc_exam_type).permit(:exam_type_name, :description, :is_deleted, :index, :mg_school_id, :created_by, :updated_by, :mg_time_table_id)
  end
end
