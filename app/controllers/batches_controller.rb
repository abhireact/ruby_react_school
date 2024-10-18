class BatchesController < ApplicationController
  layout 'mindcom'
  before_filter :login_required

  def batcheList
    puts 'StudentsHash -- is coming'
    @sql = "SELECT id, name, start_date, end_date FROM mg_batches WHERE mg_course_id = #{params[:id]} AND is_deleted = '0' AND mg_school_id = #{session[:current_user_school_id]}"
    @batch_list = MgBatch.find_by_sql(@sql)

    respond_to do |format|
      format.json { render json: @batch_list }
    end
  end

  def edit
    @batch = MgBatch.find(params[:id])
    @course = MgCourse.find_by(id: @batch.mg_course_id, is_deleted: 0, mg_school_id: session[:current_user_school_id])
    @academic_time = MgTimeTable.find_by(id: @course.mg_time_table_id, is_deleted: 0,
                                         mg_school_id: session[:current_user_school_id])

    return unless @academic_time.present?

    @start_date = @academic_time.start_date
    @end_date = @academic_time.end_date
  end

  def manage
    @timeformat = MgSchool.find_by_id(session[:current_user_school_id])
    @course_id = params[:id]
    @course = MgCourse.find(@course_id)
    @batches = MgBatch.where(mg_course_id: @course_id, mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id).paginate(
      page: params[:page], per_page: 10
    )
  end

  def new
    @course_id = params[:id]
    @course = MgCourse.find_by(id: @course_id, is_deleted: 0, mg_school_id: session[:current_user_school_id])
    @batches = MgBatch.new
    @academic_time = MgTimeTable.find_by(id: @course.mg_time_table_id, is_deleted: 0,
                                         mg_school_id: session[:current_user_school_id])

    return unless @academic_time.present?

    @start_date = @academic_time.start_date
    @end_date = @academic_time.end_date
  end

  def create
    @batch = MgBatch.new(batch_params)
    @batch.save

    @timeformat = MgSchool.find_by_id(@batch.mg_school_id)
    @startSaveDate = Date.strptime(params[:mg_batch][:start_date], @timeformat.date_format)
    @endSaveDate = Date.strptime(params[:mg_batch][:end_date], @timeformat.date_format)

    @batch.update(start_date: @startSaveDate, end_date: @endSaveDate)
    flash[:notice] = 'Batch Created Successfully'
    redirect_to action: 'manage', id: @batch.mg_course_id
  end

  def delete
    @batches = MgBatch.find(params[:id])
    time_table_array = @batches.can_destroy?

    if time_table_array.present?
      flash[:error] = 'This Batch has Dependencies'
      session[:table_array] = time_table_array
      session[:table_array_batch_id] = params[:id]
      redirect_to :back
    else
      @batches.update(is_deleted: 1)
      flash[:notice] = 'Deleted Successfully'
      redirect_to :back
    end
  end

  def show
    @course_id = params[:id]
    @batches = MgBatch.where(mg_course_id: @course_id, mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id).paginate(
      page: params[:page], per_page: 10
    )
    render layout: false
  end

  def update
    MgBatch.transaction do
      @batch = MgBatch.find(params[:id])
      @batch.update(mg_batch_params)

      @timeformat = MgSchool.find_by_id(@batch.mg_school_id)
      @startSaveDate = Date.strptime(params[:mg_batch][:start_date], @timeformat.date_format)
      @endSaveDate = Date.strptime(params[:mg_batch][:end_date], @timeformat.date_format)

      @batch.update(start_date: @startSaveDate, end_date: @endSaveDate)
      flash[:notice] = 'Batch updated Successfully'
      redirect_to action: 'manage', id: @batch.mg_course_id
    end
  end

  def destroy
    @batch = MgBatch.find(params[:id])
    @batch.update(is_deleted: 1)
    @batch_list = MgBatch.where(mg_course_id: @batch.mg_course_id, is_deleted: 0,
                                mg_school_id: session[:current_user_school_id])

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
    params.require(:mg_batch).permit(:mg_course_id, :name, :start_date, :end_date, :is_deleted, :created_by,
                                     :updated_by, :mg_school_id)
  end

  def mg_batch_params
    params.require(:mg_batch).permit(:name, :start_date, :end_date)
  end
end
