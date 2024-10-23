class BatchesController < ApplicationController
  layout "mindcom"

  def batcheList
    puts "StudentsHash -- is coming"
  
    @batch_list = MgBatch.where(
      mg_course_id: params[:id], 
      is_deleted: false, 
      mg_school_id: session[:current_user_school_id]
    ).select(:id, :name, :start_date, :end_date)
  
    
    render json: @batch_list 

  end

  def edit
    @batch = MgBatch.find(params[:id])
    @course = MgCourse.find_by(id: @batch.mg_course_id, is_deleted: 0, mg_school_id: session[:current_user_school_id])
    @academic_time = MgTimeTable.find_by(id: @course.mg_time_table_id, is_deleted: 0, mg_school_id: session[:current_user_school_id])

    if @academic_time.present?
      @start_date = @academic_time.start_date
      @end_date = @academic_time.end_date
    end
  end

  def manage
    @timeformat = MgSchool.find_by_id(session[:current_user_school_id])
    @course_id = params[:id]
    @course = MgCourse.find(@course_id)
    @batches = MgBatch.where(mg_course_id: @course_id, mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id).paginate(page: params[:page], per_page: 10)
  end

  def new
    @course_id = params[:id]
    @course = MgCourse.find_by(id: @course_id, is_deleted: 0, mg_school_id: session[:current_user_school_id])
    @batches = MgBatch.new
    @academic_time = MgTimeTable.find_by(id: @course.mg_time_table_id, is_deleted: 0, mg_school_id: session[:current_user_school_id])

    if @academic_time.present?
      @start_date = @academic_time.start_date
      @end_date = @academic_time.end_date
    end
  end

  def create
    @batch = MgBatch.new(batch_params)
    @batch.mg_school_id = session[:current_user_school_id]
    if @batch.save
      @timeformat = MgSchool.find_by_id(@batch.mg_school_id)
      
      # Parse the dates based on the school's date format
      @startSaveDate = Date.strptime(params[:mg_batch][:start_date], @timeformat.date_format)
      @endSaveDate = Date.strptime(params[:mg_batch][:end_date], @timeformat.date_format)
  
      # Update the batch with the parsed start and end dates
      @batch.update(start_date: @startSaveDate, end_date: @endSaveDate)
  
      # Render JSON for successful creation
      render json: { message: "Batch Created Successfully", batch: @batch }, status: :created
    else
      # Render JSON for failure with errors
      render json: { error: "Failed to create batch", details: @batch.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def delete
    @batches = MgBatch.find(params[:id])
    time_table_array = @batches.can_destroy?
  
    if time_table_array.present?
      # Render JSON for the scenario when the batch cannot be deleted
      render json: { error: "This Batch has Dependencies", dependencies: time_table_array }, status: :unprocessable_entity
    else
      @batches.update(is_deleted: 1)
      
      # Render JSON for successful deletion
      render json: { message: "Deleted Successfully" }, status: :ok
    end
  end

  def show
    @course_id = params[:id]
    @batches = MgBatch.where(mg_course_id: @course_id, mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id).paginate(page: params[:page], per_page: 10)
    render layout: false
  end

  def update
    MgBatch.transaction do
      @batch = MgBatch.find(params[:id])
      
      if @batch.update(mg_batch_params)
        @timeformat = MgSchool.find_by_id(@batch.mg_school_id)
        @startSaveDate = Date.strptime(params[:mg_batch][:start_date], @timeformat.date_format)
        @endSaveDate = Date.strptime(params[:mg_batch][:end_date], @timeformat.date_format)
  
        @batch.update(start_date: @startSaveDate, end_date: @endSaveDate)
  
        # Render JSON for successful update
        render json: { message: "Batch updated Successfully", batch: @batch }, status: :ok
      else
        # Render JSON for update failure
        render json: { error: "Failed to update batch", details: @batch.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
  

  def destroy
    @batch = MgBatch.find(params[:id])
    @batch.update(is_deleted: 1)
    @batch_list = MgBatch.where(mg_course_id: @batch.mg_course_id, is_deleted: 0, mg_school_id: session[:current_user_school_id])

    respond_to do |format|
      format.json { render json: @batch_list }
    end
  end

  def check_validate
    @user = MgUser.find_by(id: params[:id])
    user_name = @user&.user_name
    @bool = @user&.authenticate(user_name, params[:password])
    render json: @bool, layout: false
  end

  private

  def batch_params
    params.require(:mg_batch).permit(:mg_course_id, :name, :start_date, :end_date, :is_deleted, :created_by, :updated_by, :mg_school_id)
  end

  def mg_batch_params
    params.require(:mg_batch).permit(:name, :start_date, :end_date)
  end
end